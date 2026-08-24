using System.Text.Json.Serialization;

namespace CustomerOnboarding.Backend.Dtos;

public record BsaLoginRequestDto(
  string? Username,
  string? Password
);

public record BsaConnectionResultDto(
  bool Success,
  string Message,
  bool Authenticated,
  string? ErrorCode,
  string? RawResponse
);

public class BsaReturnItemDto
{
  [JsonPropertyName("code")]
  public string Code { get; set; } = string.Empty;

  [JsonPropertyName("value")]
  public string Value { get; set; } = string.Empty;
}

public class BsaReturnItemDictionaryDto : BsaReturnItemDto
{
  [JsonPropertyName("_description")]
  public string? Description { get; set; }

  [JsonPropertyName("_dataType")]
  public string? DataType { get; set; }

  [JsonPropertyName("_required")]
  public bool Required { get; set; }
}

public class BsaDynamicItemDto
{
  [JsonPropertyName("area")]
  public int Area { get; set; }

  [JsonPropertyName("dynamicItems")]
  public List<BsaReturnItemDto>? DynamicItems { get; set; }
}

public class BsaDynamicItemDictionaryDto
{
  [JsonPropertyName("area")]
  public int Area { get; set; }

  [JsonPropertyName("_areaName")]
  public string? AreaName { get; set; }

  [JsonPropertyName("dynamicItems")]
  public List<BsaReturnItemDictionaryDto>? DynamicItems { get; set; }
}

public class BsaReturnDictionaryDto
{
  [JsonPropertyName("returnKey")]
  public string ReturnKey { get; set; } = string.Empty;

  [JsonPropertyName("instCode")]
  public string InstCode { get; set; } = string.Empty;

  [JsonPropertyName("finYear")]
  public int FinYear { get; set; }

  [JsonPropertyName("startDate")]
  public DateTimeOffset StartDate { get; set; }

  [JsonPropertyName("endDate")]
  public DateTimeOffset EndDate { get; set; }

  [JsonPropertyName("returnItemsList")]
  public List<BsaReturnItemDictionaryDto> ReturnItemsList { get; set; } = [];

  [JsonPropertyName("dynamicItemsList")]
  public List<BsaDynamicItemDictionaryDto>? DynamicItemsList { get; set; }
}

public record BsaReturnDictionaryResponseDto(
  bool Success,
  string Message,
  BsaReturnDictionaryDto? Dictionary,
  string? RawResponse
);

public class SubmitBsaReturnRequestDto
{
  public string ReturnKey { get; set; } = string.Empty;
  public string? InstitutionCode { get; set; }
  public int FinancialYear { get; set; }
  public DateTimeOffset StartDate { get; set; }
  public DateTimeOffset EndDate { get; set; }
  public List<BsaReturnItemDto> ReturnItemsList { get; set; } = [];
  public List<BsaDynamicItemDto>? DynamicItemsList { get; set; }
}

public class BsaReturnSubmissionPayloadDto
{
  [JsonPropertyName("returnKey")]
  public string ReturnKey { get; set; } = string.Empty;

  [JsonPropertyName("instCode")]
  public string InstCode { get; set; } = string.Empty;

  [JsonPropertyName("finYear")]
  public int FinYear { get; set; }

  [JsonPropertyName("startDate")]
  public DateTimeOffset StartDate { get; set; }

  [JsonPropertyName("endDate")]
  public DateTimeOffset EndDate { get; set; }

  [JsonPropertyName("returnItemsList")]
  public List<BsaReturnItemDto> ReturnItemsList { get; set; } = [];

  [JsonPropertyName("dynamicItemsList")]
  public List<BsaDynamicItemDto>? DynamicItemsList { get; set; }

  [JsonPropertyName("filename")]
  public string? FileName { get; set; }

  [JsonPropertyName("status")]
  public string? Status { get; set; }
}

public record BsaSubmissionResultDto(
  bool Success,
  string Message,
  BsaSubmissionRecordDto Record,
  BsaReturnSubmissionPayloadDto? BsaResponse,
  string? RawResponse
);

public record BsaSubmissionRecordDto(
  int Id,
  string SubmissionReference,
  string ReturnKey,
  string InstitutionCode,
  int FinancialYear,
  DateTimeOffset PeriodStart,
  DateTimeOffset PeriodEnd,
  string? BsaFileName,
  string SubmissionStatus,
  string? Notification,
  string? LastProcessingStatus,
  string? CreatedByUserName,
  string? CreatedByBranchCode,
  DateTimeOffset CreatedAt,
  DateTimeOffset UpdatedAt,
  DateTimeOffset? SubmittedAt,
  DateTimeOffset? LastStatusCheckedAt,
  DateTimeOffset? CompletedAt,
  string? ErrorMessage,
  string? RequestPayload,
  string? SubmissionResponsePayload,
  string? StatusResponsePayload,
  string? DiscardRequestPayload,
  string? DiscardResponsePayload
);

public class BsaStatusResponseDto
{
  [JsonPropertyName("filename")]
  public string? FileName { get; set; }

  [JsonPropertyName("status")]
  public string? Status { get; set; }

  [JsonPropertyName("notification")]
  public string? Notification { get; set; }

  [JsonPropertyName("processingResults")]
  public List<BsaProcessingResultDto>? ProcessingResults { get; set; }
}

public class BsaProcessingResultDto
{
  [JsonPropertyName("number")]
  public int Number { get; set; }

  [JsonPropertyName("return_key")]
  public string? ReturnKey { get; set; }

  [JsonPropertyName("fin_year")]
  public int FinancialYear { get; set; }

  [JsonPropertyName("start_date")]
  public string? StartDate { get; set; }

  [JsonPropertyName("end_date")]
  public string? EndDate { get; set; }

  [JsonPropertyName("status")]
  public string? Status { get; set; }

  [JsonPropertyName("reception_date")]
  public string? ReceptionDate { get; set; }

  [JsonPropertyName("processing_date")]
  public string? ProcessingDate { get; set; }

  [JsonPropertyName("errors")]
  public List<BsaProcessingErrorDto>? Errors { get; set; }
}

public class BsaProcessingErrorDto
{
  [JsonPropertyName("type")]
  public string? Type { get; set; }

  [JsonPropertyName("description")]
  public string? Description { get; set; }

  [JsonPropertyName("detail")]
  public string? Detail { get; set; }
}

public record BsaStatusResultDto(
  bool Success,
  string Message,
  BsaStatusResponseDto? Status,
  BsaSubmissionRecordDto? Record,
  string? RawResponse
);

public class BsaDiscardRequestDto
{
  public string ReturnKey { get; set; } = string.Empty;
  public string? InstitutionCode { get; set; }
  public int FinancialYear { get; set; }
  public DateTimeOffset StartDate { get; set; }
  public DateTimeOffset EndDate { get; set; }
}

public record BsaDiscardResultDto(
  bool Success,
  string Message,
  BsaSubmissionRecordDto? Record,
  BsaReturnSubmissionPayloadDto? BsaResponse,
  string? RawResponse
);
