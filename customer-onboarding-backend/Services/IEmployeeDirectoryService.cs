using CustomerOnboarding.Backend.Dtos;

namespace CustomerOnboarding.Backend.Services;

public interface IEmployeeDirectoryService
{
  Task<IReadOnlyList<ExternalDirectoryUserDto>> SearchAsync(string? search, int limit = 20, CancellationToken cancellationToken = default);
  Task<ExternalDirectoryUserDto?> GetByIdAsync(string employeeDirectoryId, CancellationToken cancellationToken = default);
  Task<EmployeeDirectoryPagedResponseDto> GetPagedAsync(EmployeeDirectoryQueryDto query, CancellationToken cancellationToken = default);
  Task<EmployeeDirectoryListItemDto?> GetEntryByIdAsync(string employeeDirectoryId, CancellationToken cancellationToken = default);
  Task<EmployeeDirectoryListItemDto?> UpdateAsync(string employeeDirectoryId, UpdateEmployeeDirectoryEntryRequest request, CancellationToken cancellationToken = default);
  Task<bool> DeleteAsync(string employeeDirectoryId, CancellationToken cancellationToken = default);
  Task<EmployeeDirectoryStatsDto> GetStatsAsync(CancellationToken cancellationToken = default);
  Task<EmployeeDirectoryImportResultDto> ImportAsync(Stream workbookStream, string sourceFileName, string importedByUserName, CancellationToken cancellationToken = default);
}
