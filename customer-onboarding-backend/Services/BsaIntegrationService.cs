using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using CustomerOnboarding.Backend.Dtos;
using CustomerOnboarding.Backend.Options;
using Microsoft.Extensions.Options;

namespace CustomerOnboarding.Backend.Services;

public class BsaIntegrationService(
  HttpClient httpClient,
  IOptions<BsaOptions> bsaOptions
) : IBsaIntegrationService
{
  private static readonly JsonSerializerOptions JsonOptions = new()
  {
    PropertyNameCaseInsensitive = true
  };

  private readonly BsaOptions _options = bsaOptions.Value;

  public async Task<BsaGatewayLoginResult> AuthenticateAsync(string? usernameOverride = null, string? passwordOverride = null, CancellationToken cancellationToken = default)
  {
    var username = string.IsNullOrWhiteSpace(usernameOverride) ? _options.Username : usernameOverride.Trim();
    var password = string.IsNullOrWhiteSpace(passwordOverride) ? _options.Password : passwordOverride;

    if (string.IsNullOrWhiteSpace(_options.BaseUrl))
    {
      return new BsaGatewayLoginResult(false, false, "BSA BaseUrl is not configured.", null, "CONFIG001", string.Empty);
    }

    if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password))
    {
      return new BsaGatewayLoginResult(false, false, "BSA username/password are not configured.", null, "CONFIG002", string.Empty);
    }

    var requestPayload = new
    {
      userUser = username,
      userPass = password
    };

    var raw = string.Empty;
    int? statusCode = null;

    try
    {
      using var request = new HttpRequestMessage(HttpMethod.Post, BuildEndpoint($"api/Login/v{_options.ApiVersion}"));
      request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
      request.Content = new StringContent(JsonSerializer.Serialize(requestPayload), Encoding.UTF8, "application/json");

      using var response = await httpClient.SendAsync(request, cancellationToken);
      statusCode = (int)response.StatusCode;
      raw = await response.Content.ReadAsStringAsync(cancellationToken);

      var parsed = ParseLoginResponse(raw);
      var authenticated = parsed.Authenticated;
      var accessToken = parsed.AccessToken;
      var message = parsed.Message;
      var errorCode = parsed.ErrorCode;

      if (!authenticated && !string.IsNullOrWhiteSpace(accessToken))
      {
        authenticated = true;
      }

      if (authenticated && !string.IsNullOrWhiteSpace(accessToken))
      {
        return new BsaGatewayLoginResult(true, true, FirstNonEmpty(message, "BSA authentication succeeded."), accessToken, errorCode, raw);
      }

      return new BsaGatewayLoginResult(
        false,
        false,
        FirstNonEmpty(message, $"BSA authentication failed with HTTP {statusCode}."),
        accessToken,
        errorCode,
        raw
      );
    }
    catch (Exception ex)
    {
      return new BsaGatewayLoginResult(false, false, $"Unable to connect to BSA login endpoint. {ex.Message}", null, "HTTP500", raw);
    }
  }

  public async Task<BsaGatewayDictionaryResult> GetReturnDictionaryAsync(string returnKey, CancellationToken cancellationToken = default)
  {
    var auth = await AuthenticateAsync(cancellationToken: cancellationToken);
    if (!auth.Success || string.IsNullOrWhiteSpace(auth.AccessToken))
    {
      return new BsaGatewayDictionaryResult(false, auth.Message, null, null, auth.RawResponse);
    }

    var endpoint = $"{BuildEndpoint($"api/GetJsonReturnDictionary/v{_options.ApiVersion}")}?returnKey={Uri.EscapeDataString(returnKey)}";
    return await SendAsync<BsaReturnDictionaryDto>(HttpMethod.Get, endpoint, null, auth.AccessToken, cancellationToken)
      .ContinueWith(task =>
      {
        var response = task.Result;
        return new BsaGatewayDictionaryResult(response.Success, response.Message, response.HttpStatusCode, response.Data, response.RawResponse);
      }, cancellationToken);
  }

  public async Task<BsaGatewaySubmissionResult> SubmitAsync(BsaReturnSubmissionPayloadDto payload, CancellationToken cancellationToken = default)
  {
    var auth = await AuthenticateAsync(cancellationToken: cancellationToken);
    if (!auth.Success || string.IsNullOrWhiteSpace(auth.AccessToken))
    {
      return new BsaGatewaySubmissionResult(false, auth.Message, null, null, auth.RawResponse);
    }

    var endpoint = BuildEndpoint($"api/Submissionv2/v{_options.ApiVersion}");
    var response = await SendAsync<BsaReturnSubmissionPayloadDto>(HttpMethod.Post, endpoint, payload, auth.AccessToken, cancellationToken);
    return new BsaGatewaySubmissionResult(response.Success, response.Message, response.HttpStatusCode, response.Data, response.RawResponse);
  }

  public async Task<BsaGatewayStatusResult> GetStatusAsync(string fileName, CancellationToken cancellationToken = default)
  {
    var auth = await AuthenticateAsync(cancellationToken: cancellationToken);
    if (!auth.Success || string.IsNullOrWhiteSpace(auth.AccessToken))
    {
      return new BsaGatewayStatusResult(false, auth.Message, null, null, auth.RawResponse);
    }

    var endpoint = $"{BuildEndpoint($"api/Status/v{_options.ApiVersion}")}?fileName={Uri.EscapeDataString(fileName)}";
    var response = await SendAsync<BsaStatusResponseDto>(HttpMethod.Get, endpoint, null, auth.AccessToken, cancellationToken);
    return new BsaGatewayStatusResult(response.Success, response.Message, response.HttpStatusCode, response.Data, response.RawResponse);
  }

  public async Task<BsaGatewayDiscardResult> DiscardLastPartialSubmissionAsync(BsaDiscardRequestDto payload, CancellationToken cancellationToken = default)
  {
    var auth = await AuthenticateAsync(cancellationToken: cancellationToken);
    if (!auth.Success || string.IsNullOrWhiteSpace(auth.AccessToken))
    {
      return new BsaGatewayDiscardResult(false, auth.Message, null, null, auth.RawResponse);
    }

    var endpoint = BuildEndpoint($"api/DiscardLastPartialSubmission/v{_options.ApiVersion}");
    var response = await SendAsync<BsaReturnSubmissionPayloadDto>(HttpMethod.Post, endpoint, payload, auth.AccessToken, cancellationToken);
    return new BsaGatewayDiscardResult(response.Success, response.Message, response.HttpStatusCode, response.Data, response.RawResponse);
  }

  private async Task<BsaHttpResult<T>> SendAsync<T>(HttpMethod method, string endpoint, object? payload, string accessToken, CancellationToken cancellationToken)
  {
    var raw = string.Empty;
    int? statusCode = null;

    try
    {
      using var request = new HttpRequestMessage(method, endpoint);
      request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
      request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

      if (payload is not null)
      {
        request.Content = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");
      }

      using var response = await httpClient.SendAsync(request, cancellationToken);
      statusCode = (int)response.StatusCode;
      raw = await response.Content.ReadAsStringAsync(cancellationToken);
      var success = response.IsSuccessStatusCode;
      var message = success
        ? "BSA request completed successfully."
        : BuildErrorMessage(raw, $"BSA request failed with HTTP {statusCode}.");

      T? data = default;
      if (!string.IsNullOrWhiteSpace(raw))
      {
        try
        {
          data = JsonSerializer.Deserialize<T>(raw, JsonOptions);
        }
        catch
        {
          // Keep raw response for diagnostics if the upstream payload changes.
        }
      }

      return new BsaHttpResult<T>(success, message, statusCode, data, raw);
    }
    catch (Exception ex)
    {
      return new BsaHttpResult<T>(false, $"Unable to call BSA endpoint. {ex.Message}", statusCode, default, raw);
    }
  }

  private string BuildEndpoint(string relativePath)
  {
    return $"{_options.BaseUrl.TrimEnd('/')}/{relativePath.TrimStart('/')}";
  }

  private static (bool Authenticated, string? AccessToken, string? Message, string? ErrorCode) ParseLoginResponse(string raw)
  {
    if (string.IsNullOrWhiteSpace(raw))
    {
      return (false, null, null, null);
    }

    try
    {
      var json = JsonNode.Parse(raw);
      if (json is null)
      {
        return (false, null, null, null);
      }

      var authenticated = ReadBoolean(json, "authenticated") ?? false;
      var accessToken = FindToken(json);
      var message = ReadString(json, "message", "Message", "resultDesc", "ResultDesc");
      var errorCode = ReadString(json, "errorCode", "ErrorCode", "resultCode", "ResultCode");

      if (!authenticated && !string.IsNullOrWhiteSpace(accessToken))
      {
        authenticated = true;
      }

      return (authenticated, accessToken, message, errorCode);
    }
    catch
    {
      return (false, null, null, null);
    }
  }

  private static string? FindToken(JsonNode? node)
  {
    if (node is JsonObject obj)
    {
      foreach (var property in obj)
      {
        if (property.Value is null)
        {
          continue;
        }

        if (IsTokenField(property.Key))
        {
          var candidate = property.Value.GetValue<string?>();
          if (!string.IsNullOrWhiteSpace(candidate))
          {
            return candidate;
          }
        }

        var nested = FindToken(property.Value);
        if (!string.IsNullOrWhiteSpace(nested))
        {
          return nested;
        }
      }
    }

    if (node is JsonArray array)
    {
      foreach (var item in array)
      {
        var nested = FindToken(item);
        if (!string.IsNullOrWhiteSpace(nested))
        {
          return nested;
        }
      }
    }

    return null;
  }

  private static bool IsTokenField(string propertyName)
  {
    return propertyName.Equals("token", StringComparison.OrdinalIgnoreCase) ||
           propertyName.Equals("accessToken", StringComparison.OrdinalIgnoreCase) ||
           propertyName.Equals("access_token", StringComparison.OrdinalIgnoreCase) ||
           propertyName.Equals("jwt", StringComparison.OrdinalIgnoreCase) ||
           propertyName.Equals("jwtToken", StringComparison.OrdinalIgnoreCase) ||
           propertyName.Equals("bearerToken", StringComparison.OrdinalIgnoreCase);
  }

  private static bool? ReadBoolean(JsonNode? node, params string[] names)
  {
    if (node is not JsonObject obj)
    {
      return null;
    }

    foreach (var name in names)
    {
      foreach (var property in obj)
      {
        if (!property.Key.Equals(name, StringComparison.OrdinalIgnoreCase) || property.Value is null)
        {
          continue;
        }

        try
        {
          return property.Value.GetValue<bool>();
        }
        catch
        {
          var stringValue = property.Value.GetValue<string?>();
          if (bool.TryParse(stringValue, out var parsed))
          {
            return parsed;
          }
        }
      }
    }

    return null;
  }

  private static string? ReadString(JsonNode? node, params string[] names)
  {
    if (node is not JsonObject obj)
    {
      return null;
    }

    foreach (var name in names)
    {
      foreach (var property in obj)
      {
        if (!property.Key.Equals(name, StringComparison.OrdinalIgnoreCase) || property.Value is null)
        {
          continue;
        }

        try
        {
          return property.Value.GetValue<string?>();
        }
        catch
        {
          return property.Value.ToJsonString();
        }
      }
    }

    return null;
  }

  private static string BuildErrorMessage(string raw, string fallback)
  {
    if (string.IsNullOrWhiteSpace(raw))
    {
      return fallback;
    }

    try
    {
      var node = JsonNode.Parse(raw);
      var message = ReadString(node, "message", "Message", "title", "Title", "detail", "Detail", "resultDesc", "ResultDesc");
      return FirstNonEmpty(message, fallback);
    }
    catch
    {
      return fallback;
    }
  }

  private static string FirstNonEmpty(params string?[] values)
  {
    return values.FirstOrDefault(value => !string.IsNullOrWhiteSpace(value)) ?? string.Empty;
  }

  private sealed record BsaHttpResult<T>(bool Success, string Message, int? HttpStatusCode, T? Data, string RawResponse);
}
