
# Assign-DynamicSG.ps1
# Dynamically assign NSGs based on VM tags
$vms = Get-AzVM
foreach ($vm in $vms) {
    $tags = $vm.Tags
    if ($tags["Workload"] -eq "Web") {
        Write-Host "Assigning Web NSG to $($vm.Name)"
        # Add logic here to assign NSG
    }
}
