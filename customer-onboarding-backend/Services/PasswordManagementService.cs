using System.Text;
using System.Text.Encodings.Web;
using System.Text.RegularExpressions;
using CustomerOnboarding.Backend.Data;
using CustomerOnboarding.Backend.Dtos;
using CustomerOnboarding.Backend.Models;
using CustomerOnboarding.Backend.Options;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace CustomerOnboarding.Backend.Services;

public class PasswordManagementService(
  HttpClient httpClient,
  AppDbContext dbContext,
  IEmployeeDirectoryService employeeDirectoryService,
  IOptions<PasswordManagementOptions> options
) : IPasswordManagementService
{
  private static readonly Regex SupportedTemplateTokenRegex = new(
    @"\{\{\s*(fullEmployeeName|password|username|systemName)\s*\}\}|\{\s*(fullEmployeeName|password|username|systemName)\s*\}",
    RegexOptions.IgnoreCase | RegexOptions.CultureInvariant | RegexOptions.Compiled
  );
  private static readonly Regex LegacyCoreBankingRegex = new(
    @"core\s+banking",
    RegexOptions.IgnoreCase | RegexOptions.CultureInvariant | RegexOptions.Compiled
  );
  private static readonly Regex LegacyFlexcubeRegex = new(
    @"\bflexcube\b",
    RegexOptions.IgnoreCase | RegexOptions.CultureInvariant | RegexOptions.Compiled
  );
  private static readonly Regex LegacyResetPhraseRegex = new(
    @"your\s+flexcube\s+user\s+password",
    RegexOptions.IgnoreCase | RegexOptions.CultureInvariant | RegexOptions.Compiled
  );
  private static readonly Regex LegacyNewUserPhraseRegex = new(
    @"a\s+new\s+flexcube\s+user\s+account",
    RegexOptions.IgnoreCase | RegexOptions.CultureInvariant | RegexOptions.Compiled
  );
  private static readonly Regex GenericResetPhraseRegex = new(
    @"your\s+password\s+has\s+been\s+reset",
    RegexOptions.IgnoreCase | RegexOptions.CultureInvariant | RegexOptions.Compiled
  );
  private static readonly Regex GenericNewUserPhraseRegex = new(
    @"a\s+new\s+user\s+account\s+has\s+been\s+created\s+for\s+you",
    RegexOptions.IgnoreCase | RegexOptions.CultureInvariant | RegexOptions.Compiled
  );

  private readonly PasswordManagementOptions _options = options.Value;

  public async Task<IReadOnlyList<ExternalDirectoryUserDto>> GetExternalUsersAsync(string? search, int limit = 20, CancellationToken cancellationToken = default)
  {
    return await employeeDirectoryService.SearchAsync(search, limit, cancellationToken);
  }

  public async Task<ExternalDirectoryUserDto?> GetExternalUserAsync(string externalUserId, CancellationToken cancellationToken = default)
  {
    return await employeeDirectoryService.GetByIdAsync(externalUserId, cancellationToken);
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

  public async Task<IReadOnlyList<PasswordManagedSystemDto>> GetSystemsAsync(bool includeInactive = false, CancellationToken cancellationToken = default)
  {
    var query = dbContext.PasswordManagedSystems.AsNoTracking();
    if (!includeInactive)
    {
      query = query.Where(system => system.IsActive);
    }

    var systems = await query
      .OrderBy(system => system.Name)
      .ToListAsync(cancellationToken);

    return systems.Select(MapSystem).ToList();
  }

  public async Task<PasswordManagedSystemDto> CreateSystemAsync(CreatePasswordManagedSystemRequest request, string createdByUserName, CancellationToken cancellationToken = default)
  {
    var name = RequireSystemName(request.Name);
    var normalizedName = NormalizeSystemName(name);
    var exists = await dbContext.PasswordManagedSystems
      .AnyAsync(system => system.NormalizedName == normalizedName, cancellationToken);
    if (exists)
    {
      throw new InvalidOperationException("This target system already exists.");
    }

    var now = DateTimeOffset.UtcNow;
    var system = new PasswordManagedSystem
    {
      Name = name,
      NormalizedName = normalizedName,
      IsActive = true,
      CreatedAtUtc = now,
      CreatedByUserName = (createdByUserName ?? string.Empty).Trim(),
      UpdatedAtUtc = now,
      UpdatedByUserName = (createdByUserName ?? string.Empty).Trim()
    };

    dbContext.PasswordManagedSystems.Add(system);
    await dbContext.SaveChangesAsync(cancellationToken);
    return MapSystem(system);
  }

  public async Task<PasswordManagedSystemDto> UpdateSystemAsync(int id, UpdatePasswordManagedSystemRequest request, string updatedByUserName, CancellationToken cancellationToken = default)
  {
    var system = await dbContext.PasswordManagedSystems
      .FirstOrDefaultAsync(item => item.Id == id, cancellationToken);
    if (system is null)
    {
      throw new InvalidOperationException("Target system was not found.");
    }

    var name = RequireSystemName(request.Name);
    var normalizedName = NormalizeSystemName(name);
    var conflicts = await dbContext.PasswordManagedSystems
      .AnyAsync(item => item.Id != id && item.NormalizedName == normalizedName, cancellationToken);
    if (conflicts)
    {
      throw new InvalidOperationException("Another target system already uses this name.");
    }

    system.Name = name;
    system.NormalizedName = normalizedName;
    system.IsActive = request.IsActive;
    system.UpdatedAtUtc = DateTimeOffset.UtcNow;
    system.UpdatedByUserName = (updatedByUserName ?? string.Empty).Trim();

    await dbContext.SaveChangesAsync(cancellationToken);
    return MapSystem(system);
  }

  public async Task<PasswordMessageDispatchResultDto> SendPasswordResetSmsAsync(SendPasswordResetSmsRequest request, string requestedByUserName, CancellationToken cancellationToken = default)
  {
    var user = await RequireExternalUserAsync(request.ExternalUserId, cancellationToken);
    var systemName = await RequireActiveSystemNameAsync(request.SystemName, cancellationToken);
    var template = await RequireTemplateAsync(PasswordMessageTemplateTypes.PasswordReset, cancellationToken);
    var message = EnsureSystemNamePresent(
      PasswordMessageTemplateTypes.PasswordReset,
      template.Body,
      RenderTemplate(
      template.Body,
      user.FullEmployeeName,
      request.Password,
      systemName,
      null
      ),
      systemName
    );

    return await SendSmsAsync(
      PasswordMessageTemplateTypes.PasswordReset,
      user,
      systemName,
      message,
      requestedByUserName,
      cancellationToken
    );
  }

  public async Task<PasswordMessageDispatchResultDto> SendNewUserCredentialSmsAsync(SendNewUserCredentialSmsRequest request, string requestedByUserName, CancellationToken cancellationToken = default)
  {
    var user = await RequireExternalUserAsync(request.ExternalUserId, cancellationToken);
    var systemName = await RequireActiveSystemNameAsync(request.SystemName, cancellationToken);
    var template = await RequireTemplateAsync(PasswordMessageTemplateTypes.NewUserCreation, cancellationToken);
    var message = EnsureSystemNamePresent(
      PasswordMessageTemplateTypes.NewUserCreation,
      template.Body,
      RenderTemplate(
      template.Body,
      user.FullEmployeeName,
      request.Password,
      systemName,
      request.Username
      ),
      systemName
    );

    return await SendSmsAsync(
      PasswordMessageTemplateTypes.NewUserCreation,
      user,
      systemName,
      message,
      requestedByUserName,
      cancellationToken
    );
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
    string systemName,
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
      systemName,
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

  private static string RenderTemplate(string templateBody, string fullEmployeeName, string password, string systemName, string? username)
  {
    var tokens = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
    {
      ["fullEmployeeName"] = fullEmployeeName ?? string.Empty,
      ["password"] = password ?? string.Empty,
      ["systemName"] = systemName ?? string.Empty,
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

  private static string EnsureSystemNamePresent(string templateType, string templateBody, string renderedMessage, string systemName)
  {
    if (string.IsNullOrWhiteSpace(renderedMessage))
    {
      return renderedMessage;
    }

    if (ContainsSystemToken(templateBody))
    {
      return renderedMessage;
    }

    var normalizedMessage = renderedMessage;
    normalizedMessage = LegacyResetPhraseRegex.Replace(normalizedMessage, $"your {systemName} password");
    normalizedMessage = LegacyNewUserPhraseRegex.Replace(normalizedMessage, $"a new {systemName} user account");
    normalizedMessage = LegacyCoreBankingRegex.Replace(normalizedMessage, systemName);
    normalizedMessage = LegacyFlexcubeRegex.Replace(normalizedMessage, systemName);

    if (normalizedMessage.Contains(systemName, StringComparison.OrdinalIgnoreCase))
    {
      return normalizedMessage;
    }

    if (string.Equals(templateType, PasswordMessageTemplateTypes.PasswordReset, StringComparison.OrdinalIgnoreCase))
    {
      normalizedMessage = GenericResetPhraseRegex.Replace(normalizedMessage, $"your {systemName} password has been reset");
      if (normalizedMessage.Contains(systemName, StringComparison.OrdinalIgnoreCase))
      {
        return normalizedMessage;
      }
    }

    if (string.Equals(templateType, PasswordMessageTemplateTypes.NewUserCreation, StringComparison.OrdinalIgnoreCase))
    {
      normalizedMessage = GenericNewUserPhraseRegex.Replace(normalizedMessage, $"a new {systemName} user account has been created for you");
      if (normalizedMessage.Contains(systemName, StringComparison.OrdinalIgnoreCase))
      {
        return normalizedMessage;
      }
    }

    return $"Dear user, your credentials for {systemName} are ready. {normalizedMessage}".Trim();
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

  private static string? NormalizeTemplateType(string? templateType)
  {
    var value = (templateType ?? string.Empty).Trim().ToUpperInvariant();
    return PasswordMessageTemplateTypes.All.Contains(value, StringComparer.OrdinalIgnoreCase)
      ? value
      : null;
  }

  private static bool ContainsSystemToken(string templateBody)
  {
    return (templateBody ?? string.Empty).IndexOf("systemName", StringComparison.OrdinalIgnoreCase) >= 0;
  }

  private async Task<string> RequireActiveSystemNameAsync(string? systemName, CancellationToken cancellationToken)
  {
    var normalizedName = NormalizeSystemName(systemName);
    if (string.IsNullOrWhiteSpace(normalizedName))
    {
      throw new InvalidOperationException("Please choose a valid target system.");
    }

    var system = await dbContext.PasswordManagedSystems
      .AsNoTracking()
      .FirstOrDefaultAsync(item => item.NormalizedName == normalizedName && item.IsActive, cancellationToken);
    if (system is null)
    {
      throw new InvalidOperationException("The selected target system is not active or no longer exists.");
    }

    return system.Name;
  }

  private static string RequireSystemName(string? name)
  {
    var value = (name ?? string.Empty).Trim();
    if (string.IsNullOrWhiteSpace(value))
    {
      throw new InvalidOperationException("System name is required.");
    }
    if (value.Length > 120)
    {
      throw new InvalidOperationException("System name cannot exceed 120 characters.");
    }

    return value;
  }

  private static string NormalizeSystemName(string? name) => (name ?? string.Empty).Trim().ToUpperInvariant();

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

  private static PasswordManagedSystemDto MapSystem(PasswordManagedSystem system)
  {
    return new PasswordManagedSystemDto(
      system.Id,
      system.Name,
      system.IsActive,
      system.UpdatedAtUtc,
      system.UpdatedByUserName
    );
  }

}
