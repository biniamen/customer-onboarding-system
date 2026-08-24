using CustomerOnboarding.Backend.Data;
using Microsoft.EntityFrameworkCore;

namespace CustomerOnboarding.Backend.Services;

public interface ISchemaUpgradeService
{
  Task ApplyAsync(CancellationToken cancellationToken = default);
}

public class SchemaUpgradeService(AppDbContext dbContext) : ISchemaUpgradeService
{
  public async Task ApplyAsync(CancellationToken cancellationToken = default)
  {
    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE TABLE IF NOT EXISTS "Branches" (
        "BranchCode" character varying(3) PRIMARY KEY,
        "BranchName" character varying(120) NOT NULL,
        "IsActive" boolean NOT NULL DEFAULT TRUE
      );
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
      VALUES
        ('109', 'Stadium', TRUE),
        ('301', 'Adama', TRUE),
        ('101', 'Beklobet', TRUE)
      ON CONFLICT ("BranchCode") DO UPDATE
      SET "BranchName" = EXCLUDED."BranchName",
          "IsActive" = TRUE;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "Users"
      ADD COLUMN IF NOT EXISTS "BranchCode" character varying(3) NOT NULL DEFAULT '109';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "Users"
      ADD COLUMN IF NOT EXISTS "MustChangePassword" boolean NOT NULL DEFAULT TRUE;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "Users"
      ADD COLUMN IF NOT EXISTS "PasswordChangedAtUtc" timestamp without time zone NULL;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "Users"
      ADD COLUMN IF NOT EXISTS "BranchName" character varying(120) NOT NULL DEFAULT 'Stadium';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "OnboardingRecords"
      ADD COLUMN IF NOT EXISTS "AssetsReady" boolean NOT NULL DEFAULT TRUE;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "OnboardingRecords"
      ADD COLUMN IF NOT EXISTS "Email" character varying(160) NOT NULL DEFAULT '';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "OnboardingRecords"
      ADD COLUMN IF NOT EXISTS "MobileNumber" character varying(32) NOT NULL DEFAULT '';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "OnboardingRecords"
      ADD COLUMN IF NOT EXISTS "PlaceOfBirth" character varying(120) NOT NULL DEFAULT '';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "OnboardingRecords"
      ADD COLUMN IF NOT EXISTS "IdType" character varying(80) NOT NULL DEFAULT '';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "OnboardingRecords"
      ADD COLUMN IF NOT EXISTS "ResidentIdNumber" character varying(80);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "OnboardingRecords"
      ADD COLUMN IF NOT EXISTS "TinNumber" character varying(80);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "OnboardingRecords"
      ADD COLUMN IF NOT EXISTS "HasCustomerPhoto" boolean NOT NULL DEFAULT FALSE;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "OnboardingRecords"
      ADD COLUMN IF NOT EXISTS "HasSignature" boolean NOT NULL DEFAULT FALSE;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "OnboardingRecords"
      ADD COLUMN IF NOT EXISTS "HasRequiredDocuments" boolean NOT NULL DEFAULT FALSE;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "OnboardingRecords"
      ADD COLUMN IF NOT EXISTS "KycReviewerUserId" uuid NULL;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "OnboardingRecords"
      ADD COLUMN IF NOT EXISTS "KycReviewedAtUtc" timestamp without time zone NULL;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "OnboardingRecords"
      ADD COLUMN IF NOT EXISTS "DocumentsJson" text NOT NULL DEFAULT '[]';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      UPDATE "Users"
      SET "BranchCode" = '109'
      WHERE "BranchCode" IS NULL OR trim("BranchCode") = '';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      UPDATE "Users"
      SET "BranchName" = CASE
        WHEN "BranchCode" = '109' THEN 'Stadium'
        WHEN "BranchCode" = '301' THEN 'Adama'
        WHEN "BranchCode" = '101' THEN 'Beklobet'
        ELSE COALESCE(NULLIF(trim("BranchName"), ''), 'Unknown Branch')
      END
      WHERE "BranchName" IS NULL
         OR trim("BranchName") = ''
         OR "BranchName" IN ('Stadium', 'Unknown Branch');
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
      SELECT DISTINCT "BranchCode",
        CASE
          WHEN "BranchCode" = '109' THEN 'Stadium'
          WHEN "BranchCode" = '301' THEN 'Adama'
          WHEN "BranchCode" = '101' THEN 'Beklobet'
          ELSE COALESCE(NULLIF(trim("BranchName"), ''), 'Unknown Branch')
        END AS "BranchName",
        TRUE
      FROM "Users"
      WHERE "BranchCode" IS NOT NULL AND trim("BranchCode") <> ''
      ON CONFLICT ("BranchCode") DO UPDATE
      SET "BranchName" = EXCLUDED."BranchName";
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      UPDATE "OnboardingRecords"
      SET "AssetsReady" = TRUE
      WHERE "AssetsReady" IS DISTINCT FROM TRUE;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      UPDATE "OnboardingRecords"
      SET "HasCustomerPhoto" = COALESCE("HasCustomerPhoto", FALSE),
          "HasSignature" = COALESCE("HasSignature", FALSE),
          "HasRequiredDocuments" = COALESCE("HasRequiredDocuments", FALSE),
          "DocumentsJson" = COALESCE(NULLIF("DocumentsJson", ''), '[]'),
          "Email" = COALESCE("Email", ''),
          "MobileNumber" = COALESCE("MobileNumber", ''),
          "PlaceOfBirth" = COALESCE("PlaceOfBirth", ''),
          "IdType" = COALESCE("IdType", '')
      WHERE TRUE;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE TABLE IF NOT EXISTS "PasswordMessageTemplates" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
        "TemplateType" character varying(40) NOT NULL,
        "Title" character varying(120) NOT NULL,
        "Body" text NOT NULL,
        "IsActive" boolean NOT NULL DEFAULT TRUE,
        "UpdatedAtUtc" timestamp with time zone NOT NULL DEFAULT NOW(),
        "UpdatedByUserName" character varying(150) NOT NULL DEFAULT 'system'
      );
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE UNIQUE INDEX IF NOT EXISTS "IX_PasswordMessageTemplates_TemplateType"
      ON "PasswordMessageTemplates" ("TemplateType");
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      INSERT INTO "PasswordMessageTemplates" ("TemplateType", "Title", "Body", "IsActive", "UpdatedAtUtc", "UpdatedByUserName")
      VALUES
        ('PASSWORD_RESET', 'Password reset SMS', 'Dear {{fullEmployeeName}}, Your {{systemName}} Password has been reset to {{password}}', TRUE, NOW(), 'system'),
        ('NEW_USER_CREATION', 'New user credential SMS', 'Dear {{fullEmployeeName}}, Your New {{systemName}} Username is {{username}} and Your Password is {{password}}', TRUE, NOW(), 'system')
      ON CONFLICT ("TemplateType") DO NOTHING;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "PasswordMessageTemplates"
      ADD COLUMN IF NOT EXISTS "UpdatedByUserName" character varying(150) NOT NULL DEFAULT 'system';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      UPDATE "PasswordMessageTemplates"
      SET "Title" = COALESCE(NULLIF("Title", ''), CASE
        WHEN "TemplateType" = 'PASSWORD_RESET' THEN 'Password reset SMS'
        WHEN "TemplateType" = 'NEW_USER_CREATION' THEN 'New user credential SMS'
        ELSE 'Password SMS template'
      END),
          "Body" = COALESCE(NULLIF("Body", ''), CASE
        WHEN "TemplateType" = 'PASSWORD_RESET' THEN 'Dear {{fullEmployeeName}}, Your {{systemName}} Password has been reset to {{password}}'
        WHEN "TemplateType" = 'NEW_USER_CREATION' THEN 'Dear {{fullEmployeeName}}, Your New {{systemName}} Username is {{username}} and Your Password is {{password}}'
        ELSE ''
      END)
      WHERE TRUE;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      UPDATE "PasswordMessageTemplates"
      SET "Body" = 'Dear {{fullEmployeeName}}, Your {{systemName}} Password has been reset to {{password}}',
          "UpdatedAtUtc" = NOW(),
          "UpdatedByUserName" = 'system'
      WHERE "TemplateType" = 'PASSWORD_RESET'
        AND "Body" = 'Dear {{fullEmployeeName}}, Your Core Banking Password has been reset to {{password}}';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      UPDATE "PasswordMessageTemplates"
      SET "Body" = 'Dear {{fullEmployeeName}}, Your New {{systemName}} Username is {{username}} and Your Password is {{password}}',
          "UpdatedAtUtc" = NOW(),
          "UpdatedByUserName" = 'system'
      WHERE "TemplateType" = 'NEW_USER_CREATION'
        AND "Body" = 'Dear {{fullEmployeeName}}, Your New Core Banking Username is {{username}} and Your Password is {{password}}';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE TABLE IF NOT EXISTS "EmployeeDirectoryEntries" (
        "Id" uuid PRIMARY KEY,
        "SourceRowNumber" integer NOT NULL,
        "SequenceNumber" integer NULL,
        "FullName" character varying(220) NOT NULL,
        "FirstName" character varying(80) NOT NULL DEFAULT '',
        "MiddleName" character varying(120) NOT NULL DEFAULT '',
        "LastName" character varying(80) NOT NULL DEFAULT '',
        "EmployeeCode" character varying(32) NOT NULL DEFAULT '',
        "InternalNumber" character varying(32) NOT NULL DEFAULT '',
        "InternalNumberExtension" character varying(32) NOT NULL DEFAULT '',
        "EmployeeReference" character varying(96) NOT NULL,
        "Gender" character varying(16) NOT NULL DEFAULT '',
        "ContactAddress" character varying(120) NOT NULL DEFAULT '',
        "PhoneNumber" character varying(32) NOT NULL DEFAULT '',
        "PhoneNumberNormalized" character varying(32) NOT NULL DEFAULT '',
        "CurrentPosition" character varying(220) NOT NULL DEFAULT '',
        "Classification" character varying(80) NOT NULL DEFAULT '',
        "AssignedUnitName" character varying(220) NOT NULL DEFAULT '',
        "BranchGrade" character varying(80) NOT NULL DEFAULT '',
        "BranchCode" character varying(32) NOT NULL DEFAULT '',
        "District" character varying(80) NOT NULL DEFAULT '',
        "EmploymentDate" date NULL,
        "IsActive" boolean NOT NULL DEFAULT TRUE,
        "SourceFileName" character varying(260) NOT NULL DEFAULT '',
        "SourceSheetName" character varying(100) NOT NULL DEFAULT '',
        "ImportedAtUtc" timestamp with time zone NOT NULL DEFAULT NOW(),
        "UpdatedAtUtc" timestamp with time zone NOT NULL DEFAULT NOW()
      );
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE UNIQUE INDEX IF NOT EXISTS "IX_EmployeeDirectoryEntries_EmployeeReference"
      ON "EmployeeDirectoryEntries" ("EmployeeReference");
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE INDEX IF NOT EXISTS "IX_EmployeeDirectoryEntries_FullName"
      ON "EmployeeDirectoryEntries" ("FullName");
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE INDEX IF NOT EXISTS "IX_EmployeeDirectoryEntries_PhoneNumberNormalized"
      ON "EmployeeDirectoryEntries" ("PhoneNumberNormalized");
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE INDEX IF NOT EXISTS "IX_EmployeeDirectoryEntries_BranchCode"
      ON "EmployeeDirectoryEntries" ("BranchCode");
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE INDEX IF NOT EXISTS "IX_EmployeeDirectoryEntries_AssignedUnitName"
      ON "EmployeeDirectoryEntries" ("AssignedUnitName");
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE TABLE IF NOT EXISTS "AuditLogs" (
        "Id" bigint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
        "UserId" uuid NULL,
        "OnboardingRecordId" uuid NULL,
        "Action" character varying(80) NOT NULL,
        "EntityName" character varying(80) NOT NULL,
        "EntityId" character varying(80) NOT NULL,
        "DetailsJson" text NULL,
        "IpAddress" character varying(64) NULL,
        "CreatedAtUtc" timestamp without time zone NOT NULL DEFAULT NOW()
      );
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE TABLE IF NOT EXISTS "ResourceMobilizationRecords" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
        "RegistrationReference" character varying(40) NOT NULL,
        "RegistrationBatchReference" character varying(40) NOT NULL DEFAULT '',
        "EmployeeDirectoryEntryId" uuid NULL,
        "IsJointRegistration" boolean NOT NULL DEFAULT FALSE,
        "JointParticipantCount" integer NOT NULL DEFAULT 1,
        "JointSequenceNumber" integer NOT NULL DEFAULT 1,
        "EmployeeReference" character varying(96) NOT NULL,
        "EmployeeFullName" character varying(220) NOT NULL,
        "EmployeePhoneNumber" character varying(32),
        "EmployeeBranchCode" character varying(32),
        "EmployeeBranchName" character varying(220),
        "EmployeeDepartmentName" character varying(220),
        "EmployeePositionName" character varying(220),
        "EmployeeClassification" character varying(80),
        "MonthlyTargetAmount" numeric(18,2) NOT NULL DEFAULT 0,
        "DepositProductType" character varying(16) NOT NULL,
        "SourceTransactionAmount" numeric(18,2) NOT NULL DEFAULT 0,
        "TotalDepositMobilized" numeric(18,2) NOT NULL DEFAULT 0,
        "NewAccountCount" integer NOT NULL DEFAULT 0,
        "DepositorCustomerName" character varying(220) NOT NULL,
        "DepositorCustomerNumber" character varying(40),
        "DepositorAccountNumber" character varying(32) NOT NULL,
        "DepositorAccountClass" character varying(32),
        "TransactionReferenceNo" character varying(80) NOT NULL,
        "DepositBranchCode" character varying(32) NOT NULL,
        "DepositBranchName" character varying(220),
        "TransactionCurrency" character varying(8) NOT NULL DEFAULT 'ETB',
        "TransactionValueDate" timestamp with time zone NOT NULL,
        "Status" character varying(40) NOT NULL DEFAULT 'PENDING_CHECKER_APPROVAL',
        "MakerUserName" character varying(150),
        "MakerBranchCode" character varying(32),
        "MakerBranchName" character varying(120),
        "CheckerUserName" character varying(150),
        "CheckerBranchCode" character varying(32),
        "CheckerBranchName" character varying(120),
        "CheckerComment" character varying(300),
        "RejectionReason" character varying(300),
        "CreatedAt" timestamp with time zone NOT NULL DEFAULT NOW(),
        "UpdatedAt" timestamp with time zone NOT NULL DEFAULT NOW(),
        "ApprovedAt" timestamp with time zone,
        "RejectedAt" timestamp with time zone,
        "RequestPayload" text,
        "ResponsePayload" text
      );
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "RegistrationBatchReference" character varying(40) NOT NULL DEFAULT '';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "EmployeeDirectoryEntryId" uuid NULL;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "IsJointRegistration" boolean NOT NULL DEFAULT FALSE;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "JointParticipantCount" integer NOT NULL DEFAULT 1;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "JointSequenceNumber" integer NOT NULL DEFAULT 1;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "EmployeeReference" character varying(96) NOT NULL DEFAULT '';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "EmployeeFullName" character varying(220) NOT NULL DEFAULT '';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "EmployeePhoneNumber" character varying(32);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "EmployeeBranchCode" character varying(32);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "EmployeeBranchName" character varying(220);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "EmployeeDepartmentName" character varying(220);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "EmployeePositionName" character varying(220);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "EmployeeClassification" character varying(80);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "MonthlyTargetAmount" numeric(18,2) NOT NULL DEFAULT 0;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "DepositProductType" character varying(16) NOT NULL DEFAULT 'SAVING';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "SourceTransactionAmount" numeric(18,2) NOT NULL DEFAULT 0;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "TotalDepositMobilized" numeric(18,2) NOT NULL DEFAULT 0;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "NewAccountCount" integer NOT NULL DEFAULT 0;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "DepositorCustomerName" character varying(220) NOT NULL DEFAULT '';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "DepositorCustomerNumber" character varying(40);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "DepositorAccountNumber" character varying(32) NOT NULL DEFAULT '';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "DepositorAccountClass" character varying(32);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "TransactionReferenceNo" character varying(80) NOT NULL DEFAULT '';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "DepositBranchCode" character varying(32) NOT NULL DEFAULT '';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "DepositBranchName" character varying(220);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "TransactionCurrency" character varying(8) NOT NULL DEFAULT 'ETB';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "TransactionValueDate" timestamp with time zone NOT NULL DEFAULT NOW();
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "Status" character varying(40) NOT NULL DEFAULT 'PENDING_CHECKER_APPROVAL';
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "MakerUserName" character varying(150);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "MakerBranchCode" character varying(32);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "MakerBranchName" character varying(120);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "CheckerUserName" character varying(150);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "CheckerBranchCode" character varying(32);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "CheckerBranchName" character varying(120);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "CheckerComment" character varying(300);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "RejectionReason" character varying(300);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "CreatedAt" timestamp with time zone NOT NULL DEFAULT NOW();
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "UpdatedAt" timestamp with time zone NOT NULL DEFAULT NOW();
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "ApprovedAt" timestamp with time zone;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "RejectedAt" timestamp with time zone;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "RequestPayload" text;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "ResourceMobilizationRecords"
      ADD COLUMN IF NOT EXISTS "ResponsePayload" text;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE TABLE IF NOT EXISTS "BsaSubmissionRecords" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
        "SubmissionReference" character varying(40) NOT NULL,
        "ReturnKey" character varying(80) NOT NULL,
        "InstitutionCode" character varying(64) NOT NULL,
        "FinancialYear" integer NOT NULL,
        "PeriodStart" timestamp with time zone NOT NULL,
        "PeriodEnd" timestamp with time zone NOT NULL,
        "BsaFileName" character varying(160),
        "SubmissionStatus" character varying(64) NOT NULL DEFAULT 'CREATED',
        "Notification" character varying(500),
        "LastProcessingStatus" character varying(120),
        "CreatedByUserName" character varying(150),
        "CreatedByBranchCode" character varying(32),
        "CreatedAt" timestamp with time zone NOT NULL DEFAULT NOW(),
        "UpdatedAt" timestamp with time zone NOT NULL DEFAULT NOW(),
        "SubmittedAt" timestamp with time zone,
        "LastStatusCheckedAt" timestamp with time zone,
        "CompletedAt" timestamp with time zone,
        "RequestPayload" text,
        "SubmissionResponsePayload" text,
        "StatusResponsePayload" text,
        "DiscardRequestPayload" text,
        "DiscardResponsePayload" text,
        "ErrorMessage" text
      );
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE UNIQUE INDEX IF NOT EXISTS "IX_BsaSubmissionRecords_SubmissionReference"
      ON "BsaSubmissionRecords" ("SubmissionReference");
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE INDEX IF NOT EXISTS "IX_BsaSubmissionRecords_BsaFileName"
      ON "BsaSubmissionRecords" ("BsaFileName");
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE INDEX IF NOT EXISTS "IX_BsaSubmissionRecords_SubmissionStatus_CreatedAt"
      ON "BsaSubmissionRecords" ("SubmissionStatus", "CreatedAt" DESC);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      DROP INDEX IF EXISTS "IX_ResourceMobilizationRecords_TransactionReferenceNo";
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE UNIQUE INDEX IF NOT EXISTS "IX_ResourceMobilizationRecords_RegistrationReference"
      ON "ResourceMobilizationRecords" ("RegistrationReference");
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE INDEX IF NOT EXISTS "IX_ResourceMobilizationRecords_RegistrationBatchReference"
      ON "ResourceMobilizationRecords" ("RegistrationBatchReference");
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE INDEX IF NOT EXISTS "IX_ResourceMobilizationRecords_TransactionReferenceNo"
      ON "ResourceMobilizationRecords" ("TransactionReferenceNo");
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE INDEX IF NOT EXISTS "IX_ResourceMobilizationRecords_Status_MakerBranchCode"
      ON "ResourceMobilizationRecords" ("Status", "MakerBranchCode");
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE INDEX IF NOT EXISTS "IX_ResourceMobilizationRecords_TransactionValueDate"
      ON "ResourceMobilizationRecords" ("TransactionValueDate" DESC);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE INDEX IF NOT EXISTS "IX_ResourceMobilizationRecords_EmployeeReference"
      ON "ResourceMobilizationRecords" ("EmployeeReference");
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE TABLE IF NOT EXISTS "TelebirrTransferRequests" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
        "AccountNumber" character varying(13) NOT NULL,
        "AccountBranchCode" character varying(3),
        "CustomerName" character varying(150),
        "TelebirrShortCode" character varying(12) NOT NULL,
        "TelebirrOrganizationName" character varying(200),
        "Amount" numeric(18,2) NOT NULL DEFAULT 0,
        "Currency" character varying(3) NOT NULL DEFAULT 'ETB',
        "Narration" character varying(120) NOT NULL,
        "Status" character varying(20) NOT NULL DEFAULT 'PENDING',
        "MakerBranchId" integer,
        "MakerUserName" character varying(150),
        "CheckerUserName" character varying(150),
        "CreatedAt" timestamp with time zone NOT NULL DEFAULT NOW(),
        "ApprovedAt" timestamp with time zone,
        "RejectedAt" timestamp with time zone,
        "RejectionReason" character varying(300),
        "TransactionId" character varying(100),
        "ConversationId" character varying(100),
        "OriginatorConversationId" character varying(100),
        "CbsReference" character varying(100),
        "CbsMessageStatus" character varying(50),
        "CbsResponseDesc" character varying(500),
        "ReversalReference" character varying(100),
        "ReversalStatus" character varying(50),
        "ReversalResponseDesc" character varying(500),
        "ResponseCode" character varying(50),
        "ResponseDesc" character varying(500),
        "ServiceStatus" character varying(50),
        "ResultType" character varying(50),
        "ResultCode" character varying(50),
        "ResultDesc" character varying(500),
        "RequestPayload" text,
        "ResponsePayload" text
      );
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "TelebirrTransferRequests"
      ADD COLUMN IF NOT EXISTS "AccountBranchCode" character varying(3);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      UPDATE "TelebirrTransferRequests"
      SET "AccountBranchCode" = substring("AccountNumber" from 1 for 3)
      WHERE ("AccountBranchCode" IS NULL OR trim("AccountBranchCode") = '')
        AND "AccountNumber" IS NOT NULL
        AND length("AccountNumber") >= 3;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "TelebirrTransferRequests"
      ADD COLUMN IF NOT EXISTS "CbsReference" character varying(100);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "TelebirrTransferRequests"
      ADD COLUMN IF NOT EXISTS "CbsMessageStatus" character varying(50);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "TelebirrTransferRequests"
      ADD COLUMN IF NOT EXISTS "CbsResponseDesc" character varying(500);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "TelebirrTransferRequests"
      ADD COLUMN IF NOT EXISTS "ReversalReference" character varying(100);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "TelebirrTransferRequests"
      ADD COLUMN IF NOT EXISTS "ReversalStatus" character varying(50);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "TelebirrTransferRequests"
      ADD COLUMN IF NOT EXISTS "ReversalResponseDesc" character varying(500);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE INDEX IF NOT EXISTS "IX_TelebirrTransferRequests_Status_MakerBranchId"
      ON "TelebirrTransferRequests" ("Status", "MakerBranchId");
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE INDEX IF NOT EXISTS "IX_TelebirrTransferRequests_CreatedAt"
      ON "TelebirrTransferRequests" ("CreatedAt" DESC);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE TABLE IF NOT EXISTS "RentalPaymentRequests" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
        "ManifestId" character varying(40) NOT NULL,
        "BillId" character varying(80) NOT NULL,
        "BalerId" character varying(80) NOT NULL,
        "CustomerId" character varying(80),
        "CustomerName" character varying(200),
        "TenantName" character varying(200),
        "OwnerName" character varying(200),
        "OwnerAccountNumber" character varying(32),
        "PropertyName" character varying(200),
        "BillDescription" character varying(400),
        "Reason" character varying(500),
        "AmountDue" numeric(18,2) NOT NULL DEFAULT 0,
        "BaseAmount" numeric(18,2) NOT NULL DEFAULT 0,
        "PenaltyAmount" numeric(18,2) NOT NULL DEFAULT 0,
        "PaidAmount" numeric(18,2),
        "Status" character varying(40) NOT NULL DEFAULT 'UNPAID',
        "StatusMessage" character varying(500),
        "DebitAccount" character varying(32),
        "PaymentMode" character varying(16),
        "MakerUserName" character varying(150),
        "MakerBranchCode" character varying(3),
        "CheckerUserName" character varying(150),
        "CheckerBranchCode" character varying(3),
        "CheckerComment" character varying(300),
        "RejectionReason" character varying(300),
        "CbsReference" character varying(100),
        "ConfirmationCode" character varying(100),
        "PaidAtLocation" character varying(120),
        "TellerId" character varying(64),
        "DueDate" timestamp with time zone,
        "PaidAt" timestamp with time zone,
        "ApprovedAt" timestamp with time zone,
        "RejectedAt" timestamp with time zone,
        "CreatedAt" timestamp with time zone NOT NULL DEFAULT NOW(),
        "UpdatedAt" timestamp with time zone NOT NULL DEFAULT NOW(),
        "RequestPayload" text,
        "ResponsePayload" text
      );
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE UNIQUE INDEX IF NOT EXISTS "IX_RentalPaymentRequests_ManifestId"
      ON "RentalPaymentRequests" ("ManifestId");
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE INDEX IF NOT EXISTS "IX_RentalPaymentRequests_Status_MakerBranchCode"
      ON "RentalPaymentRequests" ("Status", "MakerBranchCode");
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      CREATE INDEX IF NOT EXISTS "IX_RentalPaymentRequests_CreatedAt"
      ON "RentalPaymentRequests" ("CreatedAt" DESC);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "RentalPaymentRequests"
      ADD COLUMN IF NOT EXISTS "OwnerAccountNumber" character varying(32);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "RentalPaymentRequests"
      ADD COLUMN IF NOT EXISTS "BaseAmount" numeric(18,2) NOT NULL DEFAULT 0;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "RentalPaymentRequests"
      ADD COLUMN IF NOT EXISTS "PenaltyAmount" numeric(18,2) NOT NULL DEFAULT 0;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "RentalPaymentRequests"
      ADD COLUMN IF NOT EXISTS "PaymentMode" character varying(16);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "RentalPaymentRequests"
      ADD COLUMN IF NOT EXISTS "CheckerUserName" character varying(150);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "RentalPaymentRequests"
      ADD COLUMN IF NOT EXISTS "CheckerBranchCode" character varying(3);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "RentalPaymentRequests"
      ADD COLUMN IF NOT EXISTS "CheckerComment" character varying(300);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "RentalPaymentRequests"
      ADD COLUMN IF NOT EXISTS "RejectionReason" character varying(300);
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "RentalPaymentRequests"
      ADD COLUMN IF NOT EXISTS "ApprovedAt" timestamp with time zone;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      ALTER TABLE "RentalPaymentRequests"
      ADD COLUMN IF NOT EXISTS "RejectedAt" timestamp with time zone;
      """,
      cancellationToken
    );

    await dbContext.Database.ExecuteSqlRawAsync(
      """
      UPDATE "RentalPaymentRequests"
      SET "BaseAmount" = COALESCE(NULLIF("BaseAmount", 0), "AmountDue"),
          "PenaltyAmount" = COALESCE("PenaltyAmount", 0),
          "PaymentMode" = COALESCE(NULLIF(trim("PaymentMode"), ''), 'ACCOUNT'),
          "Status" = CASE
            WHEN "Status" = 'PAID' THEN 'APPROVED'
            ELSE "Status"
          END
      WHERE TRUE;
      """,
      cancellationToken
    );
  }
}
