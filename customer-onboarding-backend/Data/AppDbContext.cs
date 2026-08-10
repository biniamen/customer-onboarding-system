using CustomerOnboarding.Backend.Models;
using Microsoft.EntityFrameworkCore;

namespace CustomerOnboarding.Backend.Data;

public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
  public DbSet<AppUser> Users => Set<AppUser>();
  public DbSet<Branch> Branches => Set<Branch>();
  public DbSet<OnboardingRecord> OnboardingRecords => Set<OnboardingRecord>();
  public DbSet<TelebirrTransferRequest> TelebirrTransferRequests => Set<TelebirrTransferRequest>();
  public DbSet<RentalPaymentRequest> RentalPaymentRequests => Set<RentalPaymentRequest>();
  public DbSet<PasswordMessageTemplate> PasswordMessageTemplates => Set<PasswordMessageTemplate>();
  public DbSet<AuditLog> AuditLogs => Set<AuditLog>();

  protected override void OnModelCreating(ModelBuilder modelBuilder)
  {
    base.OnModelCreating(modelBuilder);

    modelBuilder.Entity<AppUser>(entity =>
    {
      entity.HasIndex(x => x.Username).IsUnique();
      entity.Property(x => x.Username).HasMaxLength(64);
      entity.Property(x => x.FullName).HasMaxLength(160);
      entity.Property(x => x.PhoneNumber).HasMaxLength(32);
      entity.Property(x => x.BranchCode).HasMaxLength(3);
      entity.Property(x => x.BranchName).HasMaxLength(120);
      entity.Property(x => x.Role).HasMaxLength(24);
      entity.Property(x => x.MustChangePassword).HasDefaultValue(true);
    });

    modelBuilder.Entity<Branch>(entity =>
    {
      entity.HasKey(x => x.BranchCode);
      entity.Property(x => x.BranchCode).HasMaxLength(3);
      entity.Property(x => x.BranchName).HasMaxLength(120);
    });

    modelBuilder.Entity<OnboardingRecord>(entity =>
    {
      entity.HasIndex(x => x.CaseReference).IsUnique();
      entity.Property(x => x.CaseReference).HasMaxLength(40);
      entity.Property(x => x.Status).HasMaxLength(48);
      entity.Property(x => x.CustomerNumber).HasMaxLength(40);
      entity.Property(x => x.CustomerName).HasMaxLength(160);
      entity.Property(x => x.BranchCode).HasMaxLength(16);
      entity.Property(x => x.AccountClass).HasMaxLength(16);
      entity.Property(x => x.AccountClassName).HasMaxLength(160);
      entity.Property(x => x.FundingSourceType).HasMaxLength(24);
      entity.Property(x => x.FundingSourceValue).HasMaxLength(120);
      entity.Property(x => x.AccountReference).HasMaxLength(32);
      entity.Property(x => x.Email).HasMaxLength(160);
      entity.Property(x => x.MobileNumber).HasMaxLength(32);
      entity.Property(x => x.PlaceOfBirth).HasMaxLength(120);
      entity.Property(x => x.IdType).HasMaxLength(80);
      entity.Property(x => x.ResidentIdNumber).HasMaxLength(80);
      entity.Property(x => x.TinNumber).HasMaxLength(80);
      entity.Property(x => x.OpeningAmount).HasPrecision(18, 2);
      entity.HasOne(x => x.MakerUser)
        .WithMany()
        .HasForeignKey(x => x.MakerUserId)
        .OnDelete(DeleteBehavior.Restrict);
      entity.HasOne(x => x.CheckerUser)
        .WithMany()
        .HasForeignKey(x => x.CheckerUserId)
        .OnDelete(DeleteBehavior.Restrict);
      entity.HasOne(x => x.KycReviewerUser)
        .WithMany()
        .HasForeignKey(x => x.KycReviewerUserId)
        .OnDelete(DeleteBehavior.Restrict);
    });

    modelBuilder.Entity<AuditLog>(entity =>
    {
      entity.Property(x => x.Action).HasMaxLength(80);
      entity.Property(x => x.EntityName).HasMaxLength(80);
      entity.Property(x => x.EntityId).HasMaxLength(80);
      entity.Property(x => x.IpAddress).HasMaxLength(64);
    });

    modelBuilder.Entity<TelebirrTransferRequest>(entity =>
    {
      entity.Property(x => x.AccountNumber).HasMaxLength(13);
      entity.Property(x => x.AccountBranchCode).HasMaxLength(3);
      entity.Property(x => x.CustomerName).HasMaxLength(150);
      entity.Property(x => x.TelebirrShortCode).HasMaxLength(12);
      entity.Property(x => x.TelebirrOrganizationName).HasMaxLength(200);
      entity.Property(x => x.Amount).HasPrecision(18, 2);
      entity.Property(x => x.Currency).HasMaxLength(3);
      entity.Property(x => x.Narration).HasMaxLength(120);
      entity.Property(x => x.Status).HasMaxLength(20);
      entity.Property(x => x.MakerUserName).HasMaxLength(150);
      entity.Property(x => x.CheckerUserName).HasMaxLength(150);
      entity.Property(x => x.RejectionReason).HasMaxLength(300);
      entity.Property(x => x.TransactionId).HasMaxLength(100);
      entity.Property(x => x.ConversationId).HasMaxLength(100);
      entity.Property(x => x.OriginatorConversationId).HasMaxLength(100);
      entity.Property(x => x.CbsReference).HasMaxLength(100);
      entity.Property(x => x.CbsMessageStatus).HasMaxLength(50);
      entity.Property(x => x.CbsResponseDesc).HasMaxLength(500);
      entity.Property(x => x.ReversalReference).HasMaxLength(100);
      entity.Property(x => x.ReversalStatus).HasMaxLength(50);
      entity.Property(x => x.ReversalResponseDesc).HasMaxLength(500);
      entity.Property(x => x.ResponseCode).HasMaxLength(50);
      entity.Property(x => x.ResponseDesc).HasMaxLength(500);
      entity.Property(x => x.ServiceStatus).HasMaxLength(50);
      entity.Property(x => x.ResultType).HasMaxLength(50);
      entity.Property(x => x.ResultCode).HasMaxLength(50);
      entity.Property(x => x.ResultDesc).HasMaxLength(500);
      entity.HasIndex(x => new { x.Status, x.MakerBranchId });
      entity.HasIndex(x => x.CreatedAt);
    });

    modelBuilder.Entity<RentalPaymentRequest>(entity =>
    {
      entity.HasIndex(x => x.ManifestId).IsUnique();
      entity.HasIndex(x => new { x.Status, x.MakerBranchCode });
      entity.HasIndex(x => x.CreatedAt);
      entity.Property(x => x.ManifestId).HasMaxLength(40);
      entity.Property(x => x.BillId).HasMaxLength(80);
      entity.Property(x => x.BalerId).HasMaxLength(80);
      entity.Property(x => x.CustomerId).HasMaxLength(80);
      entity.Property(x => x.CustomerName).HasMaxLength(200);
      entity.Property(x => x.TenantName).HasMaxLength(200);
      entity.Property(x => x.OwnerName).HasMaxLength(200);
      entity.Property(x => x.OwnerAccountNumber).HasMaxLength(32);
      entity.Property(x => x.PropertyName).HasMaxLength(200);
      entity.Property(x => x.BillDescription).HasMaxLength(400);
      entity.Property(x => x.Reason).HasMaxLength(500);
      entity.Property(x => x.AmountDue).HasPrecision(18, 2);
      entity.Property(x => x.BaseAmount).HasPrecision(18, 2);
      entity.Property(x => x.PenaltyAmount).HasPrecision(18, 2);
      entity.Property(x => x.PaidAmount).HasPrecision(18, 2);
      entity.Property(x => x.Status).HasMaxLength(40);
      entity.Property(x => x.StatusMessage).HasMaxLength(500);
      entity.Property(x => x.DebitAccount).HasMaxLength(32);
      entity.Property(x => x.PaymentMode).HasMaxLength(16);
      entity.Property(x => x.MakerUserName).HasMaxLength(150);
      entity.Property(x => x.MakerBranchCode).HasMaxLength(3);
      entity.Property(x => x.CheckerUserName).HasMaxLength(150);
      entity.Property(x => x.CheckerBranchCode).HasMaxLength(3);
      entity.Property(x => x.CheckerComment).HasMaxLength(300);
      entity.Property(x => x.RejectionReason).HasMaxLength(300);
      entity.Property(x => x.CbsReference).HasMaxLength(100);
      entity.Property(x => x.ConfirmationCode).HasMaxLength(100);
      entity.Property(x => x.PaidAtLocation).HasMaxLength(120);
      entity.Property(x => x.TellerId).HasMaxLength(64);
    });

    modelBuilder.Entity<PasswordMessageTemplate>(entity =>
    {
      entity.HasIndex(x => x.TemplateType).IsUnique();
      entity.Property(x => x.TemplateType).HasMaxLength(40);
      entity.Property(x => x.Title).HasMaxLength(120);
      entity.Property(x => x.UpdatedByUserName).HasMaxLength(150);
    });
  }
}
