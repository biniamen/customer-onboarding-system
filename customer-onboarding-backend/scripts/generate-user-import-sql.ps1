param(
  [Parameter(Mandatory = $true)]
  [string]$ExcelPath,

  [string]$OutputSqlPath = ".\import-users.sql",

  [string]$DefaultPassword = "Gbe@1234"
)

$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.IO.Compression.FileSystem

function Get-SharedStrings {
  param(
    [System.IO.Compression.ZipArchive]$Zip
  )

  $entry = $Zip.Entries | Where-Object { $_.FullName -eq 'xl/sharedStrings.xml' } | Select-Object -First 1
  if (-not $entry) { return @() }

  $reader = New-Object System.IO.StreamReader($entry.Open())
  try {
    [xml]$xml = $reader.ReadToEnd()
  }
  finally {
    $reader.Dispose()
  }

  $ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
  $ns.AddNamespace('x', 'http://schemas.openxmlformats.org/spreadsheetml/2006/main')

  $values = @()
  foreach ($si in $xml.SelectNodes('//x:si', $ns)) {
    $text = ($si.SelectNodes('.//x:t', $ns) | ForEach-Object { $_.InnerText }) -join ''
    $values += $text
  }

  return $values
}

function Get-WorksheetRows {
  param(
    [string]$WorkbookPath
  )

  $zip = [System.IO.Compression.ZipFile]::OpenRead($WorkbookPath)
  try {
    $sharedStrings = Get-SharedStrings -Zip $zip
    $sheetEntry = $zip.Entries | Where-Object { $_.FullName -eq 'xl/worksheets/sheet1.xml' } | Select-Object -First 1
    if (-not $sheetEntry) {
      throw "sheet1.xml was not found in the workbook."
    }

    $reader = New-Object System.IO.StreamReader($sheetEntry.Open())
    try {
      [xml]$sheetXml = $reader.ReadToEnd()
    }
    finally {
      $reader.Dispose()
    }

    $ns = New-Object System.Xml.XmlNamespaceManager($sheetXml.NameTable)
    $ns.AddNamespace('x', 'http://schemas.openxmlformats.org/spreadsheetml/2006/main')

    function Get-CellValue {
      param(
        $Cell
      )

      $type = [string]$Cell.t
      if ($type -eq 'inlineStr') {
        return (($Cell.SelectNodes('./x:is//x:t', $ns) | ForEach-Object { $_.InnerText }) -join '')
      }

      $valueNode = $Cell.SelectSingleNode('./x:v', $ns)
      if (-not $valueNode) {
        return ''
      }

      $raw = [string]$valueNode.InnerText
      if ($type -eq 's') {
        return $sharedStrings[[int]$raw]
      }

      return $raw
    }

    function Get-ColumnName {
      param(
        [string]$CellReference
      )

      return ($CellReference -replace '\d', '')
    }

    $headerRow = $sheetXml.SelectSingleNode('//x:worksheet/x:sheetData/x:row[@r="1"]', $ns)
    if (-not $headerRow) {
      throw "Header row was not found."
    }

    $headerMap = @{}
    foreach ($cell in $headerRow.SelectNodes('./x:c', $ns)) {
      $headerMap[(Get-ColumnName $cell.r)] = Get-CellValue $cell
    }

    $rows = @()
    foreach ($row in $sheetXml.SelectNodes('//x:worksheet/x:sheetData/x:row[position()>1]', $ns)) {
      $item = [ordered]@{}
      foreach ($cell in $row.SelectNodes('./x:c', $ns)) {
        $column = Get-ColumnName $cell.r
        $header = $headerMap[$column]
        if (-not [string]::IsNullOrWhiteSpace($header)) {
          $item[$header] = Get-CellValue $cell
        }
      }

      if ($item.Contains('Username') -and -not [string]::IsNullOrWhiteSpace($item['Username'])) {
        $rows += [pscustomobject]$item
      }
    }

    return $rows
  }
  finally {
    $zip.Dispose()
  }
}

function New-PasswordMaterial {
  param(
    [string]$Password
  )

  $salt = New-Object byte[] 16
  $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
  try {
    $rng.GetBytes($salt)
  }
  finally {
    $rng.Dispose()
  }

  $pbkdf2 = New-Object System.Security.Cryptography.Rfc2898DeriveBytes($Password, $salt, 100000, [System.Security.Cryptography.HashAlgorithmName]::SHA256)
  try {
    $hash = $pbkdf2.GetBytes(32)
  }
  finally {
    $pbkdf2.Dispose()
  }

  return [pscustomobject]@{
    SaltHex = ([System.BitConverter]::ToString($salt) -replace '-', '').ToLowerInvariant()
    HashHex = ([System.BitConverter]::ToString($hash) -replace '-', '').ToLowerInvariant()
  }
}

function Escape-Sql {
  param(
    [AllowNull()]
    [string]$Value
  )

  if ($null -eq $Value) { return '' }
  return $Value.Replace("'", "''").Trim()
}

$resolvedExcelPath = (Resolve-Path $ExcelPath).Path
$rows = Get-WorksheetRows -WorkbookPath $resolvedExcelPath

if (-not $rows.Count) {
  throw "No user rows were found in '$resolvedExcelPath'."
}

$branchRows = $rows |
  Where-Object { -not [string]::IsNullOrWhiteSpace($_.BranchCode) } |
  Group-Object BranchCode |
  ForEach-Object {
    $first = $_.Group | Select-Object -First 1
    [pscustomobject]@{
      BranchCode = ([string]$first.BranchCode).Trim()
      BranchName = ([string]$first.BranchName).Trim()
    }
  } |
  Sort-Object BranchCode

$sql = New-Object System.Text.StringBuilder
[void]$sql.AppendLine("-- Generated $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
[void]$sql.AppendLine("-- Source workbook: $resolvedExcelPath")
[void]$sql.AppendLine("-- Default password applied to imported users: $DefaultPassword")
[void]$sql.AppendLine("BEGIN;")
[void]$sql.AppendLine()

foreach ($branch in $branchRows) {
  $branchCode = Escape-Sql $branch.BranchCode
  $branchName = Escape-Sql $branch.BranchName
  [void]$sql.AppendLine("INSERT INTO ""Branches"" (""BranchCode"", ""BranchName"", ""IsActive"")")
  [void]$sql.AppendLine("VALUES ('$branchCode', '$branchName', TRUE)")
  [void]$sql.AppendLine("ON CONFLICT (""BranchCode"") DO UPDATE")
  [void]$sql.AppendLine("SET ""BranchName"" = EXCLUDED.""BranchName"", ""IsActive"" = TRUE;")
  [void]$sql.AppendLine()
}

foreach ($row in $rows) {
  $username = Escape-Sql ([string]$row.Username)
  $fullName = Escape-Sql ([string]$row.FullName)
  $phoneNumber = Escape-Sql ([string]$row.PhoneNumber)
  $role = Escape-Sql ([string]$row.Role).ToUpperInvariant()
  $branchCode = Escape-Sql ([string]$row.BranchCode)
  $branchName = Escape-Sql ([string]$row.BranchName)
  $isActive = if (([string]$row.IsActive).Trim() -in @('1', 'true', 'TRUE', 'True', 'Y', 'YES')) { 'TRUE' } else { 'FALSE' }

  $idValue = ([string]$row.Id).Trim()
  try {
    $userId = ([guid]$idValue).ToString()
  }
  catch {
    $userId = ([guid]::NewGuid()).ToString()
  }

  $passwordMaterial = New-PasswordMaterial -Password $DefaultPassword

  [void]$sql.AppendLine("INSERT INTO ""Users"" (")
  [void]$sql.AppendLine('  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",')
  [void]$sql.AppendLine('  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"')
  [void]$sql.AppendLine(") VALUES (")
  [void]$sql.AppendLine("  '$userId', '$username', '$fullName', '$phoneNumber', '$branchCode', '$branchName', '$role',")
  [void]$sql.AppendLine("  decode('$($passwordMaterial.HashHex)', 'hex'), decode('$($passwordMaterial.SaltHex)', 'hex'), TRUE, NULL, $isActive, NOW() AT TIME ZONE 'UTC', NULL")
  [void]$sql.AppendLine(")")
  [void]$sql.AppendLine('ON CONFLICT ("Username") DO UPDATE')
  [void]$sql.AppendLine('SET "FullName" = EXCLUDED."FullName",')
  [void]$sql.AppendLine('    "PhoneNumber" = EXCLUDED."PhoneNumber",')
  [void]$sql.AppendLine('    "BranchCode" = EXCLUDED."BranchCode",')
  [void]$sql.AppendLine('    "BranchName" = EXCLUDED."BranchName",')
  [void]$sql.AppendLine('    "Role" = EXCLUDED."Role",')
  [void]$sql.AppendLine('    "PasswordHash" = EXCLUDED."PasswordHash",')
  [void]$sql.AppendLine('    "PasswordSalt" = EXCLUDED."PasswordSalt",')
  [void]$sql.AppendLine('    "MustChangePassword" = TRUE,')
  [void]$sql.AppendLine('    "PasswordChangedAtUtc" = NULL,')
  [void]$sql.AppendLine('    "IsActive" = EXCLUDED."IsActive";')
  [void]$sql.AppendLine()
}

[void]$sql.AppendLine('COMMIT;')

$resolvedOutputPath =
  if ([System.IO.Path]::IsPathRooted($OutputSqlPath)) {
    [System.IO.Path]::GetFullPath($OutputSqlPath)
  }
  else {
    [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $OutputSqlPath))
  }
[System.IO.File]::WriteAllText($resolvedOutputPath, $sql.ToString(), [System.Text.Encoding]::UTF8)

Write-Host "Users found: $($rows.Count)" -ForegroundColor Green
Write-Host "SQL file created: $resolvedOutputPath" -ForegroundColor Green
Write-Host "Default password applied: $DefaultPassword" -ForegroundColor Yellow
