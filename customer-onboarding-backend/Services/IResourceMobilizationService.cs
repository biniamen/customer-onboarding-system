using CustomerOnboarding.Backend.Dtos;

namespace CustomerOnboarding.Backend.Services;

public interface IResourceMobilizationService
{
  Task<IReadOnlyList<ResourceMobilizationEmployeeSearchResultDto>> SearchEmployeesAsync(string? search, int limit = 20, CancellationToken cancellationToken = default);
  Task<ResourceMobilizationEmployeeSearchResultDto?> GetEmployeeByIdAsync(string employeeDirectoryEntryId, CancellationToken cancellationToken = default);
  Task<IReadOnlyList<ResourceMobilizationTransactionDto>> SearchTransactionsAsync(ResourceMobilizationTransactionLookupRequest request, CancellationToken cancellationToken = default);
  Task<ResourceMobilizationTransactionDto?> GetTransactionAsync(string transactionReferenceNo, string accountNumber, CancellationToken cancellationToken = default);
}
