using System.Security.Cryptography;

namespace CustomerOnboarding.Backend.Services;

public class PasswordHasher : IPasswordHasher
{
  public void CreateHash(string password, out byte[] passwordHash, out byte[] passwordSalt)
  {
    passwordSalt = RandomNumberGenerator.GetBytes(16);
    passwordHash = Rfc2898DeriveBytes.Pbkdf2(password, passwordSalt, 100_000, HashAlgorithmName.SHA256, 32);
  }

  public bool Verify(string password, byte[] passwordHash, byte[] passwordSalt)
  {
    var computed = Rfc2898DeriveBytes.Pbkdf2(password, passwordSalt, 100_000, HashAlgorithmName.SHA256, 32);
    return CryptographicOperations.FixedTimeEquals(computed, passwordHash);
  }
}
