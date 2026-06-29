using System.Text;
using CustomerOnboarding.Backend.Data;
using CustomerOnboarding.Backend.Options;
using CustomerOnboarding.Backend.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.OpenApi.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

var builder = WebApplication.CreateBuilder(args);

builder.Services.Configure<JwtOptions>(builder.Configuration.GetSection("Jwt"));
builder.Services.Configure<FcubsOptions>(builder.Configuration.GetSection("Fcubs"));
builder.Services.Configure<TelebirrOptions>(builder.Configuration.GetSection("Telebirr"));
builder.Services.Configure<List<SeedUserOptions>>(builder.Configuration.GetSection("SeedUsers"));

builder.Services.AddDbContext<AppDbContext>(options =>
  options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddScoped<IPasswordHasher, PasswordHasher>();
builder.Services.AddScoped<ITokenService, TokenService>();
builder.Services.AddScoped<IAuditService, AuditService>();
builder.Services.AddScoped<IUserSeedService, UserSeedService>();
builder.Services.AddScoped<ISchemaUpgradeService, SchemaUpgradeService>();
builder.Services.AddScoped<IBranchWorkingDateService, BranchWorkingDateService>();
builder.Services.AddScoped<IFundingSourceLookupService, FundingSourceLookupService>();
builder.Services.AddScoped<IAccountClassLookupService, AccountClassLookupService>();
builder.Services.AddHttpClient<IAccountApprovalService, AccountApprovalService>();
builder.Services.AddHttpClient<ITelebirrTransferService, TelebirrTransferService>();

var jwtOptions = builder.Configuration.GetSection("Jwt").Get<JwtOptions>() ?? new JwtOptions();
var signingKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtOptions.Key));

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
  .AddJwtBearer(options =>
  {
    options.TokenValidationParameters = new TokenValidationParameters
    {
      ValidateIssuer = true,
      ValidateAudience = true,
      ValidateIssuerSigningKey = true,
      ValidateLifetime = true,
      ValidIssuer = jwtOptions.Issuer,
      ValidAudience = jwtOptions.Audience,
      IssuerSigningKey = signingKey,
      ClockSkew = TimeSpan.FromMinutes(2)
    };
  });

builder.Services.AddAuthorization();
builder.Services.Configure<ForwardedHeadersOptions>(options =>
{
  options.ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto;
  options.KnownNetworks.Clear();
  options.KnownProxies.Clear();
});
builder.Services.AddCors(options =>
{
  options.AddPolicy("frontend", policy =>
  {
    policy.WithOrigins("http://localhost:4200")
      .AllowAnyHeader()
      .AllowAnyMethod();
  });
});

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
  options.SwaggerDoc("v1", new OpenApiInfo
  {
    Title = "Customer Onboarding API",
    Version = "v1",
    Description = "Backend APIs for onboarding approvals and Telebirr transfer workflow."
  });

  options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
  {
    Name = "Authorization",
    Type = SecuritySchemeType.Http,
    Scheme = "bearer",
    BearerFormat = "JWT",
    In = ParameterLocation.Header,
    Description = "Enter JWT Bearer token."
  });

  options.AddSecurityRequirement(new OpenApiSecurityRequirement
  {
    {
      new OpenApiSecurityScheme
      {
        Reference = new OpenApiReference
        {
          Type = ReferenceType.SecurityScheme,
          Id = "Bearer"
        }
      },
      Array.Empty<string>()
    }
  });
});

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI(options =>
{
  options.SwaggerEndpoint("/swagger/v1/swagger.json", "Customer Onboarding API v1");
  options.RoutePrefix = "swagger";
});

app.UseForwardedHeaders();
app.UseCors("frontend");
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
  var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
  db.Database.EnsureCreated();
  var schemaUpgrade = scope.ServiceProvider.GetRequiredService<ISchemaUpgradeService>();
  await schemaUpgrade.ApplyAsync();
  var seeder = scope.ServiceProvider.GetRequiredService<IUserSeedService>();
  await seeder.SeedAsync();
}

app.Run();
