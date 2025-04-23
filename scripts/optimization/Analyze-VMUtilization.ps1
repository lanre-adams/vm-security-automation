# Placeholder for Analyze-VMUtiliz<#
.SYNOPSIS
    Analyzes utilization metrics for all VMs and exports to CSV.

.DESCRIPTION
    This script queries performance metrics (CPU, memory) for each VM
    and logs hourly usage snapshots for training the auto-scaling ML model.
#>

# Output CSV
$OutputFile = "vm-usage.csv"
if (-not (Test-Path $OutputFile)) {
    "vm_name,avg_cpu,avg_mem,hour_of_day" | Out-File -FilePath $OutputFile -Encoding utf8
}

# Connect to Azure
try {
    Connect-AzAccount -ErrorAction Stop
} catch {
    Write-Error "Failed to authenticate to Azure. Make sure you are logged in."
    return
}
# Collect VMs
$vms = Get-AzVM

foreach ($vm in $vms) {
    $vmName = $vm.Name
    $resourceGroup = $vm.ResourceGroupName

    # Get CPU & Memory usage metrics for the last 1 hour
    $metrics = Get-AzMetric -ResourceId $vm.Id `
        -TimeGrain 00:01:00 `
        -StartTime (Get-Date).AddMinutes(-60) `
        -EndTime (Get-Date) `
        -MetricName "Percentage CPU", "Available Memory Bytes"

    $cpuMetric = $metrics | Where-Object { $_.MetricName.Value -eq "Percentage CPU" }
    $memMetric = $metrics | Where-Object { $_.MetricName.Value -eq "Available Memory Bytes" }

    $avgCPU = ($cpuMetric.Data | Measure-Object Average -Property Average).Average
    $avgMemBytes = ($memMetric.Data | Measure-Object Average -Property Average).Average
    $avgMemGB = [math]::Round(($avgMemBytes / 1GB), 2)

    $hour = (Get-Date).Hour

    # Append to CSV
    "$vmName,$avgCPU,$avgMemGB,$hour" | Out-File -FilePath $OutputFile -Append -Encoding utf8

    Write-Host "✅ Collected metrics for $vmName: CPU=$avgCPU%, Mem=$avgMemGB GB"
}
