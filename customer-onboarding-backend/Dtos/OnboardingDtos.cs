using System.Text.Json;

namespace CustomerOnboarding.Backend.Dtos;

public record SupportingDocumentDto(
  string Id,
  string Category,
  string DisplayName,
  string FileName,
  string MimeType,
  string Base64,
  bool Required,
  string UploadedAtUtc
);

public record CustomerSnapshotDto(
  string FullName,
  string FirstName,
  string MiddleName,
  string LastName,
  string DateOfBirth,
  string Gender,
  string MobileNumber,
  string NationalId,
  string Psut,
  string RegionCode,
  string RegionName,
  string ZoneName,
  string WoredaName,
  string Kebele,
  string AddressLine1,
  string AddressLine2,
  string AddressLine3,
  string AddressLine4,
  string PlaceOfBirth,
  string Email,
  string ResidenceStatus,
  string PhotoBase64,
  string Nationality,
  string Country,
  bool Minor,
  JsonElement RawIdentity
);

public record AdditionalDetailsDto(
  string MotherName,
  string Occupation,
  decimal? MonthlyIncome,
  string DmsReferenceNumber,
  string Employer,
  string WorkPosition,
  string Title,
  string MaritalStatus,
  string StaffStatus,
  string MobileNumber,
  string Email,
  string PlaceOfBirth,
  string IdType,
  string? ResidentIdNumber,
  string? TinNumber,
  string? GuardianName,
  bool IsSoleProprietor = false,
  string? BusinessLicenseNumber = null,
  string? BusinessRegistrationNumber = null
);

public record AccountDetailsDto(
  string AccountClass,
  string AccountClassName,
  string AccountCode,
  string AccountNumberTemplate,
  decimal OpeningAmount,
  string FundingSourceType,
  string FundingSourceValue,
  string SignatureBase64,
  string SignatureFileType,
  string SignatureFileName,
  string ImageBase64,
  string ImageFileType,
  string ImageFileName,
  IReadOnlyList<SupportingDocumentDto>? UploadedDocuments
);

public record SubmitApprovalRequest(
  string Fan,
  string Psut,
  string CustomerNumber,
  string CustomerName,
  string BranchCode,
  string AccountClass,
  string AccountClassName,
  decimal OpeningAmount,
  string FundingSourceType,
  string FundingSourceValue,
  string AccountReference,
  CustomerSnapshotDto Snapshot,
  AdditionalDetailsDto AdditionalDetails,
  JsonElement CifResponse,
  AccountDetailsDto AccountDetails,
  JsonElement UploadResponse
);

public record ApproveRequest(string? CheckerComment);

public record RejectRequest(string CheckerComment);

public record KycDecisionRequest(string? KycComment);

public record OnboardingRecordDto(
  Guid Id,
  string CaseReference,
  string Status,
  string CustomerNumber,
  string CustomerName,
  string BranchCode,
  string AccountClass,
  string AccountClassName,
  decimal OpeningAmount,
  string FundingSourceType,
  string FundingSourceValue,
  string AccountReference,
  bool AssetsReady,
  string Email,
  string MobileNumber,
  string PlaceOfBirth,
  string IdType,
  string? ResidentIdNumber,
  string? TinNumber,
  bool HasCustomerPhoto,
  bool HasSignature,
  bool HasRequiredDocuments,
  string MakerUsername,
  string MakerFullName,
  DateTime SubmittedAtUtc,
  string? CheckerUsername,
  string? CheckerFullName,
  DateTime? ReviewedAtUtc,
  string? KycReviewerUsername,
  string? KycReviewerFullName,
  DateTime? KycReviewedAtUtc,
  string? CheckerComment,
  string? AccountNumber,
  string? LastError,
  string DocumentsJson,
  string SnapshotJson,
  string AdditionalDetailsJson,
  string CifResponseJson,
  string AccountDetailsJson,
  string UploadResponseJson,
  string TemporaryReference,
  string ScreeningStatus,
  bool HasRestrictiveScreeningMatch,
  string ScreeningDetailsJson,
  string? KycReference,
  string? KycComment,
  DateTime? KycApprovedAtUtc,
  DateTime? KycRejectedAtUtc
);

public record OnboardingReportQueryDto(
  string? Search,
  string? Status,
  DateTime? FromDate,
  DateTime? ToDate,
  int Page = 1,
  int PageSize = 10,
  string? SortBy = "submittedAtUtc",
  string? SortDirection = "desc"
);

public record OnboardingReportResponseDto(
  int Page,
  int PageSize,
  int TotalRecords,
  int TotalPages,
  IReadOnlyList<OnboardingRecordDto> Items
);

public record OnboardingStatusBreakdownDto(
  int Total,
  int Pending,
  int AccountCreated,
  int KycReviewed,
  int Failed,
  int Rejected,
  decimal TotalOpeningAmount
);

public record OnboardingBranchStatsDto(
  string BranchCode,
  string BranchName,
  OnboardingStatusBreakdownDto Today,
  OnboardingStatusBreakdownDto GrandTotal
);

public record OnboardingDashboardStatsDto(
  string Scope,
  string? BranchCode,
  DateTime RangeStartUtc,
  DateTime RangeEndUtc,
  OnboardingStatusBreakdownDto Today,
  OnboardingStatusBreakdownDto GrandTotal,
  IReadOnlyList<OnboardingBranchStatsDto> Branches
);

public record EligibleFundingAccountDto(
  string AccountNumber,
  string AccountDescription,
  string Currency,
  string AccountClass,
  string NoDebitStatus,
  string DormantStatus,
  string JoinIndicator
);

public record AccountClassOptionDto(
  string Code,
  string Name,
  string AccountCode,
  decimal MinimumOpeningBalance,
  string CurrencyCode
);
