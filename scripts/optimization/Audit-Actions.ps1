param (
    [string]$VMName,
    [string]$ActionType,        # e.g. 'Scale', 'Stop', 'NSG_Assignment', 'Agent_Deploy'
    [string]$Result,            # e.g. 'Success', 'Failed'
    [string]$Details = ""
)

# Define log directory and ensure it exists
$LogDir = "logs"
if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir | Out-Null
}

# Define log file path
$LogFile = Join-Path $LogDir "vm_automation_audit_log.csv"

# Prepare log entry
$entry = [PSCustomObject]@{
    Timestamp  = (Get-Date).ToString("s")
    VMName     = $VMName
    Action     = $ActionType
    Result     = $Result
    Details    = $Details
}

# Export to CSV
if (-not (Test-Path $LogFile)) {
    $entry | Export-Csv -Path $LogFile -NoTypeInformation
} else {
    $entry | Export-Csv -Path $LogFile -Append -NoTypeInformation
}

Write-Host "📝 Action logged for $VMName: [$ActionType - $Result]" -ForegroundColor Cyan
