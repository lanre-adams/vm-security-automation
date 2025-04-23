<#
.SYNOPSIS
    Correlates security events across VMs from activity logs and diagnostic metrics.

.DESCRIPTION
    Scans recent logs for suspicious patterns like login failures, agent uninstallations,
    and abnormal VM operations. Appends results to a structured audit log.
#>

param (
    [datetime]$StartTime = (Get-Date).AddHours(-6),
    [datetime]$EndTime = (Get-Date)
)

$LogFile = "logs/security_event_log.csv"

# Ensure log directory exists
if (-not (Test-Path "logs")) {
    New-Item -ItemType Directory -Path "logs" | Out-Null
}

# Header if first time
if (-not (Test-Path $LogFile)) {
    "Timestamp,VMName,EventType,Severity,Details" | Out-File -FilePath $LogFile -Encoding utf8
}

# Get all VMs
$vms = Get-AzVM

foreach ($vm in $vms) {
    $vmId = $vm.Id
    $vmName = $vm.Name

    # Query activity logs
    $logs = Get-AzLog -ResourceId $vmId -StartTime $StartTime -EndTime $EndTime

    foreach ($log in $logs) {
        $eventType = $log.OperationName.LocalizedValue
        $status = $log.Status.Value
        $desc = $log.Description

        # Filter: Security-specific
        if ($eventType -match "Delete|Restart|Deallocate|Update|Action") {
            "$($log.EventTimestamp),$vmName,$eventType,$status,$desc" | Out-File -FilePath $LogFile -Append -Encoding utf8
        }

        if ($desc -match "failed logon|agent removed|unauthorized") {
            "$($log.EventTimestamp),$vmName,SuspiciousActivity,Critical,$desc" | Out-File -FilePath $LogFile -Append -Encoding utf8
        }
    }
}

Write-Host "✅ Security event correlation complete. Log saved to $LogFile" -ForegroundColor Green
