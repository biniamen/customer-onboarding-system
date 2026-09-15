using System.Text.Json;
using CustomerOnboarding.Backend.Data;
using CustomerOnboarding.Backend.Dtos;
using CustomerOnboarding.Backend.Models;
using Microsoft.EntityFrameworkCore;

namespace CustomerOnboarding.Backend.Services;

public record OnboardingScreeningMatch(
  string Type,
  string Severity,
  string Summary,
  string? Source,
  string? Reference,
  bool Restrictive
);

public record OnboardingScreeningResult(
  string Status,
  bool HasRestrictiveMatch,
  IReadOnlyList<OnboardingScreeningMatch> Matches
);

public interface IOnboardingScreeningService
{
  Task<OnboardingScreeningResult> EvaluateAsync(OnboardingRecord record, CancellationToken cancellationToken = default);
}

public class OnboardingScreeningService(AppDbContext dbContext) : IOnboardingScreeningService
{
  private static readonly string[] RestrictiveCategories = ["SANCTION", "WATCHLIST", "NBE_RESTRICTED", "INTERNAL_BLACKLIST"];
  private static readonly JsonSerializerOptions JsonOptions = new() { PropertyNameCaseInsensitive = true };

  public async Task<OnboardingScreeningResult> EvaluateAsync(OnboardingRecord record, CancellationToken cancellationToken = default)
  {
    var snapshot = Deserialize<CustomerSnapshotDto>(record.SnapshotJson);
    var details = Deserialize<AdditionalDetailsDto>(record.AdditionalDetailsJson);
    var name = snapshot?.FullName ?? record.CustomerName;
    var nationalId = snapshot?.NationalId ?? record.Psut;
    var mobile = details?.MobileNumber ?? record.MobileNumber;
    var normalizedName = Normalize(name);
    var normalizedId = Normalize(nationalId);
    var normalizedMobile = NormalizeDigits(mobile);
    var matches = new List<OnboardingScreeningMatch>();

    var watchlistEntries = await dbContext.WatchlistEntries
      .AsNoTracking()
      .Where(entry => entry.IsActive)
      .ToListAsync(cancellationToken);

    foreach (var entry in watchlistEntries)
    {
      var documentMatch = !string.IsNullOrWhiteSpace(normalizedId) &&
        string.Equals(Normalize(entry.DocumentNumber), normalizedId, StringComparison.Ordinal);
      var nameMatch = IsNameMatch(normalizedName, entry.NormalizedName, entry.AlternateNames);
      if (!documentMatch && !nameMatch)
      {
        continue;
      }

      var restrictive = entry.IsSanctioned || RestrictiveCategories.Contains(entry.ScreeningCategory, StringComparer.OrdinalIgnoreCase);
      matches.Add(new OnboardingScreeningMatch(
        documentMatch ? "National ID watchlist match" : "Name watchlist match",
        restrictive ? "RESTRICTIVE" : (entry.IsPep ? "SUGGESTIVE" : "REVIEW"),
        entry.FullName,
        entry.SourceList,
        entry.SourceReference,
        restrictive));
    }

    if (!string.IsNullOrWhiteSpace(normalizedMobile))
    {
      var phoneMatches = await dbContext.OnboardingRecords
        .AsNoTracking()
        .Where(item => item.Id != record.Id && item.MobileNumber == normalizedMobile &&
          item.Status != WorkflowStatuses.KycRejected && item.Status != WorkflowStatuses.Rejected)
        .OrderByDescending(item => item.SubmittedAtUtc)
        .Take(5)
        .Select(item => new { item.CaseReference, item.CustomerName, item.Status })
        .ToListAsync(cancellationToken);

      matches.AddRange(phoneMatches.Select(item => new OnboardingScreeningMatch(
        "Telephone similarity", "SUGGESTIVE", item.CustomerName, "Onboarding register", item.CaseReference, false)));
    }

    if (!string.IsNullOrWhiteSpace(normalizedName))
    {
      var candidates = await dbContext.OnboardingRecords
        .AsNoTracking()
        .Where(item => item.Id != record.Id && item.Status != WorkflowStatuses.KycRejected && item.Status != WorkflowStatuses.Rejected)
        .OrderByDescending(item => item.SubmittedAtUtc)
        .Take(250)
        .Select(item => new { item.CaseReference, item.CustomerName, item.Status })
        .ToListAsync(cancellationToken);

      matches.AddRange(candidates
        .Where(item => IsSimilarName(normalizedName, Normalize(item.CustomerName)))
        .Take(5)
        .Select(item => new OnboardingScreeningMatch(
          "Customer name similarity", "SUGGESTIVE", item.CustomerName, "Onboarding register", item.CaseReference, false)));
    }

    var distinctMatches = matches
      .GroupBy(match => $"{match.Type}|{match.Reference}|{match.Summary}", StringComparer.OrdinalIgnoreCase)
      .Select(group => group.First())
      .ToList();
    var hasRestrictive = distinctMatches.Any(match => match.Restrictive);
    return new OnboardingScreeningResult(
      distinctMatches.Count == 0 ? "CLEAR" : "MATCH_FOUND",
      hasRestrictive,
      distinctMatches);
  }

  private static T? Deserialize<T>(string json)
  {
    try
    {
      return JsonSerializer.Deserialize<T>(json, JsonOptions);
    }
    catch (JsonException)
    {
      return default;
    }
  }

  private static bool IsNameMatch(string subject, string watchlistName, string? aliases)
  {
    if (string.IsNullOrWhiteSpace(subject))
    {
      return false;
    }

    if (string.Equals(subject, Normalize(watchlistName), StringComparison.Ordinal))
    {
      return true;
    }

    return (aliases ?? string.Empty)
      .Split([';', ',', '|'], StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
      .Select(Normalize)
      .Any(alias => string.Equals(subject, alias, StringComparison.Ordinal));
  }

  private static bool IsSimilarName(string left, string right)
  {
    if (left.Length < 6 || right.Length < 6)
    {
      return false;
    }

    return left.Contains(right, StringComparison.Ordinal) || right.Contains(left, StringComparison.Ordinal);
  }

  private static string Normalize(string? value) => new((value ?? string.Empty)
    .Where(char.IsLetterOrDigit)
    .Select(char.ToUpperInvariant)
    .ToArray());

  private static string NormalizeDigits(string? value) => new((value ?? string.Empty)
    .Where(char.IsDigit)
    .ToArray());
}
