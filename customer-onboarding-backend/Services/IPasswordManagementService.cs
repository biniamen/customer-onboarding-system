using CustomerOnboarding.Backend.Dtos;

namespace CustomerOnboarding.Backend.Services;

public interface IPasswordManagementService
{
  Task<IReadOnlyList<ExternalDirectoryUserDto>> GetExternalUsersAsync(string? search, int limit = 20, CancellationToken cancellationToken = default);
  Task<ExternalDirectoryUserDto?> GetExternalUserAsync(string externalUserId, CancellationToken cancellationToken = default);
  Task<IReadOnlyList<PasswordMessageTemplateDto>> GetTemplatesAsync(CancellationToken cancellationToken = default);
  Task<PasswordMessageTemplateDto> SaveTemplateAsync(string templateType, UpdatePasswordMessageTemplateRequest request, string updatedByUserName, CancellationToken cancellationToken = default);
  Task<IReadOnlyList<PasswordManagedSystemDto>> GetSystemsAsync(bool includeInactive = false, CancellationToken cancellationToken = default);
  Task<PasswordManagedSystemDto> CreateSystemAsync(CreatePasswordManagedSystemRequest request, string createdByUserName, CancellationToken cancellationToken = default);
  Task<PasswordManagedSystemDto> UpdateSystemAsync(int id, UpdatePasswordManagedSystemRequest request, string updatedByUserName, CancellationToken cancellationToken = default);
  Task<PasswordMessageDispatchResultDto> SendPasswordResetSmsAsync(SendPasswordResetSmsRequest request, string requestedByUserName, CancellationToken cancellationToken = default);
  Task<PasswordMessageDispatchResultDto> SendNewUserCredentialSmsAsync(SendNewUserCredentialSmsRequest request, string requestedByUserName, CancellationToken cancellationToken = default);
}
