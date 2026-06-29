using System.Text.Json;
using CustomerOnboarding.Backend.Data;
using CustomerOnboarding.Backend.Models;

namespace CustomerOnboarding.Backend.Services;

public class AuditService(AppDbContext dbContext) : IAuditService
{
  public async Task LogAsync(Guid? userId, Guid? onboardingRecordId, string action, string entityName, string entityId, object? details, string? ipAddress, CancellationToken cancellationToken = default)
  {
    dbContext.AuditLogs.Add(new AuditLog
    {
      UserId = userId,
      OnboardingRecordId = onboardingRecordId,
      Action = action,
      EntityName = entityName,
      EntityId = entityId,
      DetailsJson = details is null ? null : JsonSerializer.Serialize(details),
      IpAddress = ipAddress,
      CreatedAtUtc = DateTime.UtcNow
    });

    await dbContext.SaveChangesAsync(cancellationToken);
  }
}
