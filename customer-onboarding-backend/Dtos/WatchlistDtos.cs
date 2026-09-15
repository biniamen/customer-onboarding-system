namespace CustomerOnboarding.Backend.Dtos;

public record WatchlistQueryDto(
  string? Search,
  string? Category,
  string? SourceList,
  bool? IsActive,
  int Page = 1,
  int PageSize = 20
);

public record WatchlistEntryDto(
  string Id,
  string FullName,
  string? AlternateNames,
  string ScreeningCategory,
  string SourceList,
  string? SourceReference,
  string? RiskLevel,
  string? Nationality,
  DateOnly? DateOfBirth,
  string? PlaceOfBirth,
  string? DocumentType,
  string? DocumentNumber,
  string? PositionOrRole,
  string? Organization,
  string? Country,
  string? CityOrRegion,
  string? Address,
  DateOnly? ListedOn,
  DateOnly? ExpiryDate,
  bool IsActive,
  bool IsPep,
  bool IsSanctioned,
  bool RequiresEnhancedDueDiligence,
  string? Remarks,
  string? SourceUrl,
  string? ImportedFileName,
  int? SourceRowNumber,
  string? CreatedByUserName,
  string? UpdatedByUserName,
  DateTimeOffset CreatedAtUtc,
  DateTimeOffset UpdatedAtUtc
);

public record WatchlistPagedResponseDto(
  int Page,
  int PageSize,
  int TotalRecords,
  int TotalPages,
  int ActiveRecords,
  int PepRecords,
  int SanctionRecords,
  IReadOnlyList<WatchlistEntryDto> Items
);

public record UpsertWatchlistEntryRequest(
  string? FullName,
  string? AlternateNames,
  string? ScreeningCategory,
  string? SourceList,
  string? SourceReference,
  string? RiskLevel,
  string? Nationality,
  DateOnly? DateOfBirth,
  string? PlaceOfBirth,
  string? DocumentType,
  string? DocumentNumber,
  string? PositionOrRole,
  string? Organization,
  string? Country,
  string? CityOrRegion,
  string? Address,
  DateOnly? ListedOn,
  DateOnly? ExpiryDate,
  bool IsActive,
  bool IsPep,
  bool IsSanctioned,
  bool RequiresEnhancedDueDiligence,
  string? Remarks,
  string? SourceUrl
);

public record WatchlistImportResultDto(
  string WorksheetName,
  int ProcessedRows,
  int InsertedRows,
  int UpdatedRows,
  int SkippedBlankRows,
  IReadOnlyList<string> Errors
);
