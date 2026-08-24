using System.Security.Claims;
using CustomerOnboarding.Backend.Dtos;
using CustomerOnboarding.Backend.Models;
using CustomerOnboarding.Backend.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CustomerOnboarding.Backend.Controllers;

[ApiController]
[Route("api/core/employee-directory")]
[Authorize(Roles = $"{UserRoles.Admin},{UserRoles.SystemAdmin},{UserRoles.Hr}")]
public class EmployeeDirectoryController(
  IEmployeeDirectoryService employeeDirectoryService,
  IAuditService auditService
) : ControllerBase
{
  [HttpGet]
  public async Task<ActionResult<EmployeeDirectoryPagedResponseDto>> GetEmployees(
    [FromQuery] EmployeeDirectoryQueryDto query,
    CancellationToken cancellationToken)
  {
    var result = await employeeDirectoryService.GetPagedAsync(query, cancellationToken);
    return Ok(result);
  }

  [HttpGet("{id}")]
  public async Task<ActionResult<EmployeeDirectoryListItemDto>> GetEmployee(string id, CancellationToken cancellationToken)
  {
    var employee = await employeeDirectoryService.GetEntryByIdAsync(id, cancellationToken);
    return employee is null
      ? NotFound(new { message = "Employee directory entry was not found." })
      : Ok(employee);
  }

  [HttpPut("{id}")]
  public async Task<ActionResult<EmployeeDirectoryListItemDto>> UpdateEmployee(
    string id,
    [FromBody] UpdateEmployeeDirectoryEntryRequest request,
    CancellationToken cancellationToken)
  {
    try
    {
      var employee = await employeeDirectoryService.UpdateAsync(id, request, cancellationToken);
      if (employee is null)
      {
        return NotFound(new { message = "Employee directory entry was not found." });
      }

      await auditService.LogAsync(
        GetCurrentUserId(),
        null,
        "UPDATE_EMPLOYEE_DIRECTORY_ENTRY",
        "EmployeeDirectoryEntry",
        employee.Id,
        new { employee.EmployeeReference, employee.FullEmployeeName, employee.BranchCode, employee.IsActive },
        HttpContext.Connection.RemoteIpAddress?.ToString(),
        cancellationToken
      );

      return Ok(employee);
    }
    catch (InvalidOperationException ex)
    {
      return BadRequest(new { message = ex.Message });
    }
  }

  [HttpDelete("{id}")]
  public async Task<IActionResult> DeleteEmployee(string id, CancellationToken cancellationToken)
  {
    var employee = await employeeDirectoryService.GetEntryByIdAsync(id, cancellationToken);
    if (employee is null)
    {
      return NotFound(new { message = "Employee directory entry was not found." });
    }

    var deleted = await employeeDirectoryService.DeleteAsync(id, cancellationToken);
    if (!deleted)
    {
      return NotFound(new { message = "Employee directory entry was not found." });
    }

    await auditService.LogAsync(
      GetCurrentUserId(),
      null,
      "DELETE_EMPLOYEE_DIRECTORY_ENTRY",
      "EmployeeDirectoryEntry",
      employee.Id,
      new { employee.EmployeeReference, employee.FullEmployeeName, employee.BranchCode },
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );

    return NoContent();
  }

  private Guid? GetCurrentUserId()
  {
    var raw = User.FindFirstValue(ClaimTypes.NameIdentifier);
    return Guid.TryParse(raw, out var userId) ? userId : null;
  }
}
