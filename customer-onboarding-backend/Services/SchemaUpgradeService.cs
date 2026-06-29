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
  }
}
