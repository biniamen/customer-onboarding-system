using System.Security.Claims;
using ImageMagick;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CustomerOnboarding.Backend.Controllers;

[ApiController]
[Route("api/core/identity-photo")]
[Authorize]
public class IdentityPhotoController : ControllerBase
{
  [HttpPost("preview")]
  public ActionResult<IdentityPhotoPreviewResponse> Preview([FromBody] IdentityPhotoPreviewRequest request)
  {
    var normalized = NormalizeBase64(request.PhotoBase64);
    if (string.IsNullOrWhiteSpace(normalized))
    {
      return Ok(new IdentityPhotoPreviewResponse(string.Empty));
    }

    if (normalized.StartsWith("data:", StringComparison.OrdinalIgnoreCase))
    {
      return Ok(new IdentityPhotoPreviewResponse(normalized));
    }

    try
    {
      var bytes = Convert.FromBase64String(normalized);
      var imageBytes = bytes;
      var jpeg2000Start = FindJpeg2000Signature(bytes);
      if (jpeg2000Start >= 0)
      {
        imageBytes = bytes[jpeg2000Start..];
      }

      using var image = new MagickImage(imageBytes);
      image.AutoOrient();
      image.Format = MagickFormat.Png;
      var pngBytes = image.ToByteArray(MagickFormat.Png);
      return Ok(new IdentityPhotoPreviewResponse($"data:image/png;base64,{Convert.ToBase64String(pngBytes)}"));
    }
    catch
    {
      return Ok(new IdentityPhotoPreviewResponse($"data:{DetectRasterMimeType(normalized)};base64,{normalized}"));
    }
  }

  private static string NormalizeBase64(string? value)
  {
    return string.Concat((value ?? string.Empty).Where(ch => !char.IsWhiteSpace(ch))).Trim();
  }

  private static int FindJpeg2000Signature(IReadOnlyList<byte> bytes)
  {
    byte[][] signatures =
    [
      [0xff, 0x4f, 0xff, 0x51],
      [0x00, 0x00, 0x00, 0x0c, 0x6a, 0x50, 0x20, 0x20]
    ];

    foreach (var signature in signatures)
    {
      for (var index = 0; index <= bytes.Count - signature.Length; index += 1)
      {
        var matched = true;
        for (var offset = 0; offset < signature.Length; offset += 1)
        {
          if (bytes[index + offset] != signature[offset])
          {
            matched = false;
            break;
          }
        }

        if (matched)
        {
          return index;
        }
      }
    }

    return -1;
  }

  private static string DetectRasterMimeType(string base64)
  {
    try
    {
      var bytes = Convert.FromBase64String(base64);
      if (bytes.Length >= 8 &&
          bytes[0] == 0x89 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x4e &&
          bytes[3] == 0x47)
      {
        return "image/png";
      }

      if (bytes.Length >= 3 &&
          bytes[0] == 0xff &&
          bytes[1] == 0xd8 &&
          bytes[2] == 0xff)
      {
        return "image/jpeg";
      }
    }
    catch
    {
      // Fall through to the default mime type.
    }

    return "image/jpeg";
  }
}

public sealed record IdentityPhotoPreviewRequest(string PhotoBase64);

public sealed record IdentityPhotoPreviewResponse(string DataUrl);
