namespace CustomerOnboarding.Backend.Services;

public interface IAuditService
{
  Task LogAsync(Guid? userId, Guid? onboardingRecordId, string action, string entityName, string entityId, object? details, string? ipAddress, CancellationToken cancellationToken = default);
}
