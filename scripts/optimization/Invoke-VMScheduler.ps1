
# Invoke-VMScheduler.ps1
# Automatically shuts down low-priority VMs during off-hours
$usageData = Import-Csv "vm-usage.csv"
foreach ($vm in $usageData) {
    if ($vm.AvgCPU -lt 10 -and $vm.Hour -ge 18) {
        Stop-AzVM -Name $vm.Name -Force
        Write-Host "Stopped VM: $($vm.Name)"
    }
}
