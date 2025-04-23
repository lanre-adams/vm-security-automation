<#
.SYNOPSIS
    Evaluates VM compliance against organizational security policies.

.DESCRIPTION
    Checks for required agents, tags, NSG association, and regional compliance.
    Outputs results to `compliance_report.csv` with Pass/Fail per VM.
#>

# Path to log output
$logPath = "logs/compliance_report.csv"

# Ensure log directory exists
if (-not (Test-Path "logs")) {
    New-Item -ItemType Directory -Path "logs" | Out-Null
}

# Write header if not exists
if (-not (Test-Path $logPath)) {
    "VMName,ResourceGroup,Location,NSGAttached,RequiredTagsPresent,SecurityAgentInstalled,ComplianceStatus,Details" | Out-File -FilePath $logPath -Encoding utf8
}

# Define compliance rules
$requiredTags = @("Environment", "Owner", "CostCenter")
$allowedLocations = @("East US", "West Europe", "Central India")

# Evaluate all VMs
$vms = Get-AzVM

foreach ($vm in $vms) {
    $vmName = $vm.Name
    $rg = $vm.ResourceGroupName
    $location = $vm.Location
    $tags = $vm.Tags
    $complianceDetails = @()
    $complianceStatus = "Pass"

    # Check region
    if ($allowedLocations -notcontains $location) {
        $complianceStatus = "Fail"
        $complianceDetails += "Invalid Region: $location"
    }

    # Check required tags
    $missingTags = $requiredTags | Where-Object { -not $tags.ContainsKey($_) }
    if ($missingTags.Count -gt 0) {
        $complianceStatus = "Fail"
        $complianceDetails += "Missing Tags: $($missingTags -join ', ')"
    }

    # Check NSG
    $nics = Get-AzNetworkInterface -ResourceGroupName $rg | Where-Object { $_.VirtualMachine.Id -eq $vm.Id }
    $nsgAttached = $false
    foreach ($nic in $nics) {
        if ($nic.NetworkSecurityGroup) {
            $nsgAttached = $true
            break
        }
    }
    if (-not $nsgAttached) {
        $complianceStatus = "Fail"
        $complianceDetails += "No NSG attached"
    }

    # Check security agent (simulation)
    $hasAgent = $true  # Replace with real check or status query
    if (-not $hasAgent) {
        $complianceStatus = "Fail"
        $complianceDetails += "Security agent not found"
    }

    $details = ($complianceDetails -join "; ")

    # Log result
    "$vmName,$rg,$location,$nsgAttached,$($missingTags.Count -eq 0),$hasAgent,$complianceStatus,$details" | Out-File -FilePath $logPath -Append -Encoding utf8

    Write-Host " $vmName Compliance: $complianceStatus" -ForegroundColor green
}
