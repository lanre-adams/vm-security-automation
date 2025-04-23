
# Scale-VMs.ps1
# Resize VMs using ML prediction file
$json = Get-Content "ml/scale_recommendations.json" | ConvertFrom-Json
foreach ($vm in $json.VMs) {
    Resize-AzVM -VMName $vm.Name -Size $vm.RecommendedSize
    Write-Host "Resized $($vm.Name) to $($vm.RecommendedSize)"
}
