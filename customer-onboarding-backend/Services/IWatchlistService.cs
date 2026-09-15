using CustomerOnboarding.Backend.Dtos;

namespace CustomerOnboarding.Backend.Services;

public interface IWatchlistService
{
  Task<WatchlistPagedResponseDto> GetPagedAsync(WatchlistQueryDto query, CancellationToken cancellationToken = default);
  Task<WatchlistEntryDto?> GetByIdAsync(string id, CancellationToken cancellationToken = default);
  Task<WatchlistEntryDto> CreateAsync(UpsertWatchlistEntryRequest request, string userName, CancellationToken cancellationToken = default);
  Task<WatchlistEntryDto?> UpdateAsync(string id, UpsertWatchlistEntryRequest request, string userName, CancellationToken cancellationToken = default);
  Task<bool> DeleteAsync(string id, CancellationToken cancellationToken = default);
  Task<WatchlistImportResultDto> ImportAsync(Stream stream, string fileName, string userName, CancellationToken cancellationToken = default);
  byte[] BuildImportTemplate();
}
