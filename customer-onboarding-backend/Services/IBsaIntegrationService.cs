using CustomerOnboarding.Backend.Dtos;

namespace CustomerOnboarding.Backend.Services;

public interface IBsaIntegrationService
{
  Task<BsaGatewayLoginResult> AuthenticateAsync(string? usernameOverride = null, string? passwordOverride = null, CancellationToken cancellationToken = default);
  Task<BsaGatewayDictionaryResult> GetReturnDictionaryAsync(string returnKey, CancellationToken cancellationToken = default);
  Task<BsaGatewaySubmissionResult> SubmitAsync(BsaReturnSubmissionPayloadDto payload, CancellationToken cancellationToken = default);
  Task<BsaGatewayStatusResult> GetStatusAsync(string fileName, CancellationToken cancellationToken = default);
  Task<BsaGatewayDiscardResult> DiscardLastPartialSubmissionAsync(BsaDiscardRequestDto payload, CancellationToken cancellationToken = default);
}

public record BsaGatewayLoginResult(
  bool Success,
  bool Authenticated,
  string Message,
  string? AccessToken,
  string? ErrorCode,
  string RawResponse
);

public record BsaGatewayDictionaryResult(
  bool Success,
  string Message,
  int? HttpStatusCode,
  BsaReturnDictionaryDto? Dictionary,
  string RawResponse
);

public record BsaGatewaySubmissionResult(
  bool Success,
  string Message,
  int? HttpStatusCode,
  BsaReturnSubmissionPayloadDto? Submission,
  string RawResponse
);

public record BsaGatewayStatusResult(
  bool Success,
  string Message,
  int? HttpStatusCode,
  BsaStatusResponseDto? Status,
  string RawResponse
);

public record BsaGatewayDiscardResult(
  bool Success,
  string Message,
  int? HttpStatusCode,
  BsaReturnSubmissionPayloadDto? Submission,
  string RawResponse
);
