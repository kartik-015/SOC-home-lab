# Fix VMnet1 IP Address to 192.168.56.1
# Run as Administrator

# Find the VMnet1 adapter
$adapter = Get-NetAdapter | Where-Object { $_.Name -like "*VMnet1*" }

if ($adapter) {
    Write-Host "Found adapter: $($adapter.Name)" -ForegroundColor Green
    
    # Remove existing IP configuration (if any)
    Remove-NetIPAddress -InterfaceAlias $adapter.Name -Confirm:$false -ErrorAction SilentlyContinue
    Remove-NetRoute -InterfaceAlias $adapter.Name -Confirm:$false -ErrorAction SilentlyContinue
    
    # Configure static IP
    New-NetIPAddress -InterfaceAlias $adapter.Name `
                     -IPAddress 192.168.56.1 `
                     -PrefixLength 24 `
                     -ErrorAction Stop
    
    Write-Host "VMnet1 configured with IP: 192.168.56.1" -ForegroundColor Green
    Write-Host "Verifying configuration..." -ForegroundColor Yellow
    
    # Verify
    Get-NetIPAddress -InterfaceAlias $adapter.Name | Where-Object { $_.IPAddress -like "192.168.56.*" }
    
} else {
    Write-Host "VMnet1 adapter not found!" -ForegroundColor Red
    Write-Host "Please ensure VMware Network Adapter VMnet1 is installed." -ForegroundColor Yellow
}

