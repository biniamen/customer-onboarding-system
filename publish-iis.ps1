$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$frontendPath = Join-Path $root "customer-onboarding"
$backendPath = Join-Path $root "customer-onboarding-backend"
$deployRoot = Join-Path $root "deploy"
$frontendOut = Join-Path $deployRoot "frontend"
$backendOut = Join-Path $deployRoot "backend"

if (Test-Path $frontendOut) {
  Remove-Item -LiteralPath $frontendOut -Recurse -Force
}

if (Test-Path $backendOut) {
  Remove-Item -LiteralPath $backendOut -Recurse -Force
}

New-Item -ItemType Directory -Path $frontendOut | Out-Null
New-Item -ItemType Directory -Path $backendOut | Out-Null

Write-Host "Building Angular frontend..." -ForegroundColor Cyan
Push-Location $frontendPath
npm.cmd run build
Copy-Item -Path (Join-Path $frontendPath "dist\customer-onboarding\*") -Destination $frontendOut -Recurse -Force
Pop-Location

Write-Host "Publishing .NET backend..." -ForegroundColor Cyan
Push-Location $backendPath
if (-not (Test-Path (Join-Path $backendPath "obj\project.assets.json"))) {
  dotnet restore --configfile (Join-Path $backendPath "NuGet.Config")
}
dotnet publish --no-restore -c Release -o $backendOut -p:UseAppHost=false
Pop-Location

Write-Host "Deployment build is ready." -ForegroundColor Green
Write-Host "Frontend: $frontendOut"
Write-Host "Backend:  $backendOut"
