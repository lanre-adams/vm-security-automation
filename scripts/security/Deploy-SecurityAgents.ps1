
# Deploy-SecurityAgents.ps1
# Automatically deploy security tools to all VMs
$vms = Get-AzVM
foreach ($vm in $vms) {
    Write-Host "Deploying security agent to $($vm.Name)"
    # Add logic to deploy agent, e.g., using Custom Script Extension
}
# Placeholder for Deploy-SecurityAgents.ps1
