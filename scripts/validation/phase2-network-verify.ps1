# Phase 2 Network Verification Script
# Run this script from the Windows 11 host to verify network configuration

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Phase 2: Network Connectivity Verification" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check VMware Network Adapter
Write-Host "[1] Checking VMware Network Adapter (VMnet1)..." -ForegroundColor Yellow
$vmnetAdapter = Get-NetAdapter | Where-Object { $_.InterfaceDescription -like "*VMnet*" -or $_.Name -like "*VMnet*" }
if ($vmnetAdapter) {
    Write-Host "    ✓ VMware Network Adapter found" -ForegroundColor Green
    $vmnetIP = Get-NetIPAddress | Where-Object { $_.IPAddress -like "192.168.56.*" }
    if ($vmnetIP) {
        Write-Host "    ✓ Host IP configured: $($vmnetIP.IPAddress)" -ForegroundColor Green
    } else {
        Write-Host "    ✗ Host IP not configured (expected: 192.168.56.1)" -ForegroundColor Red
    }
} else {
    Write-Host "    ✗ VMware Network Adapter not found" -ForegroundColor Red
    Write-Host "      Please configure VMnet1 in VMware Network Editor" -ForegroundColor Yellow
}

Write-Host ""

# Test Connectivity to VMs
Write-Host "[2] Testing Connectivity to VMs..." -ForegroundColor Yellow

$vms = @(
    @{Name="SIEM Server"; IP="192.168.56.10"},
    @{Name="Windows 7 VM"; IP="192.168.56.20"},
    @{Name="Kali Linux VM"; IP="192.168.56.30"}
)

$allReachable = $true
foreach ($vm in $vms) {
    Write-Host "    Testing $($vm.Name) ($($vm.IP))..." -NoNewline
    $pingResult = Test-Connection -ComputerName $vm.IP -Count 2 -Quiet -ErrorAction SilentlyContinue
    if ($pingResult) {
        Write-Host " ✓ REACHABLE" -ForegroundColor Green
    } else {
        Write-Host " ✗ UNREACHABLE" -ForegroundColor Red
        $allReachable = $false
    }
}

Write-Host ""

# Verify Network Isolation (No Internet)
Write-Host "[3] Verifying Network Isolation..." -ForegroundColor Yellow
Write-Host "    Testing internet connectivity (should FAIL)..." -NoNewline
$internetTest = Test-Connection -ComputerName "8.8.8.8" -Count 2 -Quiet -ErrorAction SilentlyContinue
if ($internetTest) {
    Write-Host " ✗ WARNING: Internet accessible (isolation may be compromised)" -ForegroundColor Yellow
} else {
    Write-Host " ✓ No internet access (isolation verified)" -ForegroundColor Green
}

Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Verification Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

if ($allReachable -and $vmnetIP) {
    Write-Host "✓ Network configuration appears correct" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Yellow
    Write-Host "  1. Verify static IPs are configured on each VM" -ForegroundColor White
    Write-Host "  2. Verify inter-VM connectivity from within VMs" -ForegroundColor White
    Write-Host "  3. Proceed to Phase 3: Log Collection" -ForegroundColor White
} else {
    Write-Host "✗ Network configuration issues detected" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting Steps:" -ForegroundColor Yellow
    Write-Host "  1. Ensure all VMs are powered on" -ForegroundColor White
    Write-Host "  2. Verify VMware Network Editor configuration" -ForegroundColor White
    Write-Host "  3. Check static IP configuration on each VM" -ForegroundColor White
    Write-Host "  4. Verify firewall settings (ICMP may be blocked)" -ForegroundColor White
}

Write-Host ""

