using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Text.Encodings.Web;
using System.Text.RegularExpressions;
using CustomerOnboarding.Backend.Data;
using CustomerOnboarding.Backend.Dtos;
using CustomerOnboarding.Backend.Models;
using CustomerOnboarding.Backend.Options;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Options;

namespace CustomerOnboarding.Backend.Services;

public class PasswordManagementService(
  HttpClient httpClient,
  AppDbContext dbContext,
  IMemoryCache memoryCache,
  IOptions<PasswordManagementOptions> options
) : IPasswordManagementService
{
  private static readonly JsonSerializerOptions JsonOptions = new()
  {
    PropertyNameCaseInsensitive = true
  };
  private static readonly Regex SupportedTemplateTokenRegex = new(
    @"\{\{\s*(fullEmployeeName|password|username)\s*\}\}|\{\s*(fullEmployeeName|password|username)\s*\}",
    RegexOptions.IgnoreCase | RegexOptions.CultureInvariant | RegexOptions.Compiled
  );
  private const string ExternalUsersCacheKey = "password-management:external-users";
  private static readonly TimeSpan ExternalUsersCacheDuration = TimeSpan.FromMinutes(5);

  private readonly PasswordManagementOptions _options = options.Value;

  public async Task<IReadOnlyList<ExternalDirectoryUserDto>> GetExternalUsersAsync(string? search, int limit = 20, CancellationToken cancellationToken = default)
  {
    var normalizedSearch = (search ?? string.Empty).Trim();
    if (normalizedSearch.Length < 2)
    {
      return [];
    }

    var term = normalizedSearch.ToLowerInvariant();
    var cappedLimit = Math.Clamp(limit, 5, 50);
    var users = await FetchExternalUsersAsync(cancellationToken);

    return users
      .Select(user => new
      {
        User = user,
        Score = ScoreUser(user, term)
      })
      .Where(item => item.Score > 0)
      .OrderByDescending(item => item.Score)
      .ThenBy(item => item.User.FullEmployeeName)
      .ThenBy(item => item.User.EmployeeId)
      .Select(item => item.User)
      .Take(cappedLimit)
      .ToList();
  }

  public async Task<ExternalDirectoryUserDto?> GetExternalUserAsync(string externalUserId, CancellationToken cancellationToken = default)
  {
    if (string.IsNullOrWhiteSpace(externalUserId))
    {
      return null;
    }

    var users = await FetchExternalUsersAsync(cancellationToken);
    return users.FirstOrDefault(user => string.Equals(user.Id, externalUserId.Trim(), StringComparison.OrdinalIgnoreCase));
  }

  public async Task<IReadOnlyList<PasswordMessageTemplateDto>> GetTemplatesAsync(CancellationToken cancellationToken = default)
  {
    var templates = await dbContext.PasswordMessageTemplates
      .AsNoTracking()
      .OrderBy(template => template.TemplateType)
      .ToListAsync(cancellationToken);

    return templates.Select(MapTemplate).ToList();
  }

  public async Task<PasswordMessageTemplateDto> SaveTemplateAsync(string templateType, UpdatePasswordMessageTemplateRequest request, string updatedByUserName, CancellationToken cancellationToken = default)
  {
    var normalizedType = NormalizeTemplateType(templateType);
    if (normalizedType is null)
    {
      throw new InvalidOperationException("Unsupported password SMS template type.");
    }

    var template = await dbContext.PasswordMessageTemplates
      .FirstOrDefaultAsync(item => item.TemplateType == normalizedType, cancellationToken);

    if (template is null)
    {
      template = new PasswordMessageTemplate
      {
        TemplateType = normalizedType
      };
      dbContext.PasswordMessageTemplates.Add(template);
    }

    template.Title = (request.Title ?? string.Empty).Trim();
    template.Body = (request.Body ?? string.Empty).Trim();
    template.IsActive = request.IsActive;
    template.UpdatedAtUtc = DateTimeOffset.UtcNow;
    template.UpdatedByUserName = (updatedByUserName ?? string.Empty).Trim();

    await dbContext.SaveChangesAsync(cancellationToken);
    return MapTemplate(template);
  }

  public async Task<PasswordMessageDispatchResultDto> SendPasswordResetSmsAsync(SendPasswordResetSmsRequest request, string requestedByUserName, CancellationToken cancellationToken = default)
  {
    var user = await RequireExternalUserAsync(request.ExternalUserId, cancellationToken);
    var template = await RequireTemplateAsync(PasswordMessageTemplateTypes.PasswordReset, cancellationToken);
    var message = RenderTemplate(
      template.Body,
      user.FullEmployeeName,
      request.Password,
      null
    );

    return await SendSmsAsync(
      PasswordMessageTemplateTypes.PasswordReset,
      user,
      message,
      requestedByUserName,
      cancellationToken
    );
  }

  public async Task<PasswordMessageDispatchResultDto> SendNewUserCredentialSmsAsync(SendNewUserCredentialSmsRequest request, string requestedByUserName, CancellationToken cancellationToken = default)
  {
    var user = await RequireExternalUserAsync(request.ExternalUserId, cancellationToken);
    var template = await RequireTemplateAsync(PasswordMessageTemplateTypes.NewUserCreation, cancellationToken);
    var message = RenderTemplate(
      template.Body,
      user.FullEmployeeName,
      request.Password,
      request.Username
    );

    return await SendSmsAsync(
      PasswordMessageTemplateTypes.NewUserCreation,
      user,
      message,
      requestedByUserName,
      cancellationToken
    );
  }

  private async Task<IReadOnlyList<ExternalDirectoryUserDto>> FetchExternalUsersAsync(CancellationToken cancellationToken)
  {
    if (memoryCache.TryGetValue<IReadOnlyList<ExternalDirectoryUserDto>>(ExternalUsersCacheKey, out var cachedUsers) &&
        cachedUsers is not null)
    {
      return cachedUsers;
    }

    if (string.IsNullOrWhiteSpace(_options.DirectoryBaseUrl))
    {
      throw new InvalidOperationException("Password management employee directory base URL is not configured.");
    }

    var requestUri = BuildUri(_options.DirectoryBaseUrl, _options.DirectoryUsersPath);
    using var request = new HttpRequestMessage(HttpMethod.Get, requestUri);
    request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("text/plain"));

    if (!string.IsNullOrWhiteSpace(_options.DirectoryApiKey))
    {
      request.Headers.TryAddWithoutValidation(
        string.IsNullOrWhiteSpace(_options.DirectoryApiKeyHeader) ? "X-API-Key" : _options.DirectoryApiKeyHeader,
        _options.DirectoryApiKey
      );
    }

    using var response = await httpClient.SendAsync(request, cancellationToken);
    var raw = await response.Content.ReadAsStringAsync(cancellationToken);
    if (!response.IsSuccessStatusCode)
    {
      throw new InvalidOperationException($"Unable to load external users. {response.StatusCode}: {raw}");
    }

    var payload = JsonSerializer.Deserialize<ExternalUserEnvelope>(raw, JsonOptions);
    var users = payload?.Data is null
      ? new List<ExternalDirectoryUserDto>()
      : payload.Data.Select(MapExternalUser).ToList();

    memoryCache.Set(ExternalUsersCacheKey, users, ExternalUsersCacheDuration);
    return users;
  }

  private async Task<PasswordMessageTemplate> RequireTemplateAsync(string templateType, CancellationToken cancellationToken)
  {
    var template = await dbContext.PasswordMessageTemplates
      .AsNoTracking()
      .FirstOrDefaultAsync(item => item.TemplateType == templateType && item.IsActive, cancellationToken);

    if (template is null)
    {
      throw new InvalidOperationException($"The {templateType} SMS template is not configured or is inactive.");
    }

    return template;
  }

  private async Task<ExternalDirectoryUserDto> RequireExternalUserAsync(string externalUserId, CancellationToken cancellationToken)
  {
    var user = await GetExternalUserAsync(externalUserId, cancellationToken);
    if (user is null)
    {
      throw new InvalidOperationException("The selected external user was not found.");
    }

    if (!user.IsActive)
    {
      throw new InvalidOperationException("The selected external user is inactive.");
    }

    if (string.IsNullOrWhiteSpace(user.PhoneNumber))
    {
      throw new InvalidOperationException("The selected external user does not have a phone number.");
    }

    return user;
  }

  private async Task<PasswordMessageDispatchResultDto> SendSmsAsync(
    string templateType,
    ExternalDirectoryUserDto user,
    string messageBody,
    string requestedByUserName,
    CancellationToken cancellationToken)
  {
    var normalizedPhone = NormalizePhoneNumber(user.PhoneNumber);
    if (string.IsNullOrWhiteSpace(normalizedPhone))
    {
      throw new InvalidOperationException("Unable to normalize the destination phone number.");
    }

    if (string.IsNullOrWhiteSpace(_options.SmsFrom))
    {
      throw new InvalidOperationException("Password SMS sender number is not configured.");
    }

    if (string.IsNullOrWhiteSpace(_options.SmsBaseUrl))
    {
      throw new InvalidOperationException("Password SMS gateway base URL is not configured.");
    }

    if (string.IsNullOrWhiteSpace(_options.SmsUsername) || string.IsNullOrWhiteSpace(_options.SmsPassword))
    {
      throw new InvalidOperationException("Password SMS gateway credentials are not configured.");
    }

    var requestUrl = BuildSmsGatewayUrl(normalizedPhone, messageBody);
    using var request = new HttpRequestMessage(HttpMethod.Get, requestUrl);
    using var response = await httpClient.SendAsync(request, cancellationToken);
    var raw = await response.Content.ReadAsStringAsync(cancellationToken);

    return new PasswordMessageDispatchResultDto(
      templateType,
      user.Id,
      user.FullEmployeeName,
      normalizedPhone,
      messageBody,
      response.IsSuccessStatusCode,
      response.IsSuccessStatusCode
        ? "SMS sent successfully."
        : $"SMS sending failed with status {(int)response.StatusCode}.",
      raw,
      DateTimeOffset.UtcNow
    );
  }

  private string BuildSmsGatewayUrl(string phoneNumber, string messageBody)
  {
    var encoder = UrlEncoder.Default;
    var needsUnicode = _options.SmsForceUnicodeMode || !IsGsm7(messageBody);
    var baseUrl = _options.SmsBaseUrl.Trim();
    var username = encoder.Encode(_options.SmsUsername.Trim());
    var password = encoder.Encode(_options.SmsPassword.Trim());
    var from = encoder.Encode(_options.SmsFrom.Trim());
    var to = encoder.Encode(phoneNumber);
    var priority = encoder.Encode(_options.SmsPriority.ToString());

    if (needsUnicode && _options.SmsUseUcs2Hex)
    {
      var hex = ToUcs2Hex(messageBody);
      return
        $"{baseUrl}?username={username}" +
        $"&password={password}" +
        $"&from={from}" +
        $"&to={to}" +
        $"&text={hex}" +
        $"&coding=2&unicode=1" +
        $"&priority={priority}";
    }

    if (needsUnicode)
    {
      return
        $"{baseUrl}?username={username}" +
        $"&password={password}" +
        $"&from={from}" +
        $"&to={to}" +
        $"&text={encoder.Encode(messageBody)}" +
        $"&coding=2&unicode=1&charset=utf-8" +
        $"&priority={priority}";
    }

    return
      $"{baseUrl}?username={username}" +
      $"&password={password}" +
      $"&from={from}" +
      $"&to={to}" +
      $"&text={encoder.Encode(messageBody)}" +
      $"&priority={priority}";
  }

  private string NormalizePhoneNumber(string phoneNumber)
  {
    var raw = (phoneNumber ?? string.Empty).Trim();
    if (string.IsNullOrWhiteSpace(raw))
    {
      return string.Empty;
    }

    var digits = new string(raw.Where(char.IsDigit).ToArray());
    if (string.IsNullOrWhiteSpace(digits))
    {
      return string.Empty;
    }

    var countryCodeDigits = new string((_options.DefaultCountryCode ?? string.Empty).Where(char.IsDigit).ToArray());
    if (!string.IsNullOrWhiteSpace(countryCodeDigits) &&
        digits.StartsWith(countryCodeDigits, StringComparison.Ordinal) &&
        digits.Length > countryCodeDigits.Length)
    {
      return $"0{digits[countryCodeDigits.Length..]}";
    }

    if (!digits.StartsWith("0", StringComparison.Ordinal) && digits.Length == 9)
    {
      return $"0{digits}";
    }

    return digits;
  }

  private static string RenderTemplate(string templateBody, string fullEmployeeName, string password, string? username)
  {
    var tokens = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
    {
      ["fullEmployeeName"] = fullEmployeeName ?? string.Empty,
      ["password"] = password ?? string.Empty,
      ["username"] = username ?? string.Empty
    };

    return SupportedTemplateTokenRegex.Replace(templateBody ?? string.Empty, match =>
    {
      var tokenName = !string.IsNullOrWhiteSpace(match.Groups[1].Value)
        ? match.Groups[1].Value
        : match.Groups[2].Value;

      return !string.IsNullOrWhiteSpace(tokenName) && tokens.TryGetValue(tokenName, out var tokenValue)
        ? tokenValue
        : match.Value;
    });
  }

  private static bool IsGsm7(string value)
  {
    if (string.IsNullOrEmpty(value))
    {
      return true;
    }

    foreach (var character in value)
    {
      if (character > 0x7F)
      {
        return false;
      }
    }

    return true;
  }

  private static string ToUcs2Hex(string value)
  {
    var bytes = Encoding.BigEndianUnicode.GetBytes(value ?? string.Empty);
    var builder = new StringBuilder(bytes.Length * 2);
    foreach (var current in bytes)
    {
      builder.Append(current.ToString("X2"));
    }

    return builder.ToString();
  }

  private static string BuildUri(string baseUrl, string path)
  {
    var trimmedBase = (baseUrl ?? string.Empty).TrimEnd('/');
    var trimmedPath = string.IsNullOrWhiteSpace(path) ? string.Empty : "/" + path.TrimStart('/');
    return $"{trimmedBase}{trimmedPath}";
  }

  private static string? NormalizeTemplateType(string? templateType)
  {
    var value = (templateType ?? string.Empty).Trim().ToUpperInvariant();
    return PasswordMessageTemplateTypes.All.Contains(value, StringComparer.OrdinalIgnoreCase)
      ? value
      : null;
  }

  private static int ScoreUser(ExternalDirectoryUserDto user, string term)
  {
    var score = 0;
    score += ScoreValue(user.EmployeeId, term, 140);
    score += ScoreValue(user.FullEmployeeName, term, 120);
    score += ScoreValue(user.FirstName, term, 95);
    score += ScoreValue(user.MiddleName, term, 80);
    score += ScoreValue(user.LastName, term, 80);
    score += ScoreValue(user.PhoneNumber, term, 110);
    score += ScoreValue(user.BranchCode, term, 100);
    score += ScoreValue(user.BranchName, term, 95);
    score += ScoreValue(user.DepartmentName, term, 70);
    score += ScoreValue(user.PositionName, term, 60);
    score += ScoreValue(user.Email, term, 50);
    return score;
  }

  private static int ScoreValue(string? value, string term, int baseScore)
  {
    if (string.IsNullOrWhiteSpace(value))
    {
      return 0;
    }

    var normalizedValue = value.Trim();
    if (normalizedValue.Equals(term, StringComparison.OrdinalIgnoreCase))
    {
      return baseScore + 40;
    }

    if (normalizedValue.StartsWith(term, StringComparison.OrdinalIgnoreCase))
    {
      return baseScore + 20;
    }

    return normalizedValue.Contains(term, StringComparison.OrdinalIgnoreCase) ? baseScore : 0;
  }

  private static ExternalDirectoryUserDto MapExternalUser(ExternalUserPayload source)
  {
    var firstName = (source.FirstName ?? string.Empty).Trim();
    var middleName = (source.MiddleName ?? string.Empty).Trim();
    var lastName = (source.LastName ?? string.Empty).Trim();
    var fullName = string.Join(' ', new[] { firstName, middleName, lastName }.Where(value => !string.IsNullOrWhiteSpace(value)));
    if (string.IsNullOrWhiteSpace(fullName))
    {
      fullName = (source.FullEmployeeName ?? source.FullName ?? source.Name ?? string.Empty).Trim();
    }

    return new ExternalDirectoryUserDto(
      source.Id ?? string.Empty,
      (source.EmployeeId ?? string.Empty).Trim(),
      firstName,
      middleName,
      lastName,
      fullName,
      (source.Gender ?? string.Empty).Trim(),
      (source.Email ?? string.Empty).Trim(),
      (source.PhoneNumber ?? source.MobileNumber ?? source.Phone ?? string.Empty).Trim(),
      source.IsActive,
      source.BranchId,
      source.BranchName,
      source.BranchCode,
      source.DepartmentId,
      source.DepartmentName,
      source.RoleId,
      source.RoleName,
      source.PositionId,
      source.PositionName,
      source.MustChangePassword,
      source.LastPasswordResetAt,
      source.LastPasswordResetByUserId,
      source.CreatedAt,
      source.UpdatedAt
    );
  }

  private static PasswordMessageTemplateDto MapTemplate(PasswordMessageTemplate template)
  {
    return new PasswordMessageTemplateDto(
      template.TemplateType,
      template.Title,
      template.Body,
      template.IsActive,
      template.UpdatedAtUtc,
      template.UpdatedByUserName
    );
  }

  private sealed class ExternalUserEnvelope
  {
    public bool Success { get; set; }
    public string? Message { get; set; }
    public List<ExternalUserPayload>? Data { get; set; }
  }

  private sealed class ExternalUserPayload
  {
    public string? Id { get; set; }
    public string? EmployeeId { get; set; }
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
    public string? MiddleName { get; set; }
    public string? FullEmployeeName { get; set; }
    public string? FullName { get; set; }
    public string? Name { get; set; }
    public string? Gender { get; set; }
    public string? Email { get; set; }
    public string? PhoneNumber { get; set; }
    public string? MobileNumber { get; set; }
    public string? Phone { get; set; }
    public bool IsActive { get; set; }
    public string? BranchId { get; set; }
    public string? BranchName { get; set; }
    public string? BranchCode { get; set; }
    public string? DepartmentId { get; set; }
    public string? DepartmentName { get; set; }
    public string? RoleId { get; set; }
    public string? RoleName { get; set; }
    public string? PositionId { get; set; }
    public string? PositionName { get; set; }
    public bool MustChangePassword { get; set; }
    public DateTimeOffset? LastPasswordResetAt { get; set; }
    public string? LastPasswordResetByUserId { get; set; }
    public DateTimeOffset? CreatedAt { get; set; }
    public DateTimeOffset? UpdatedAt { get; set; }
  }
}
