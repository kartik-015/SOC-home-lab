#!/bin/bash
# Phase 2 Network Verification Script
# Run this script from SIEM Server or Kali Linux to verify network configuration

echo "========================================"
echo "Phase 2: Network Connectivity Verification"
echo "========================================"
echo ""

# Check current IP configuration
echo "[1] Current IP Configuration:"
echo "----------------------------------------"
CURRENT_IP=$(ip addr show | grep -oP 'inet \K[\d.]+' | grep -v '127.0.0.1' | head -1)
if [ -n "$CURRENT_IP" ]; then
    echo "    Current IP: $CURRENT_IP"
    
    # Determine which VM this is based on IP
    case $CURRENT_IP in
        192.168.56.10)
            echo "    ✓ SIEM Server (Expected: 192.168.56.10)"
            ;;
        192.168.56.20)
            echo "    ⚠ Windows 7 VM detected (run from Linux VM)"
            ;;
        192.168.56.30)
            echo "    ✓ Kali Linux VM (Expected: 192.168.56.30)"
            ;;
        *)
            echo "    ✗ Unexpected IP address"
            ;;
    esac
else
    echo "    ✗ No IP address configured"
fi

echo ""

# Test Connectivity to Other VMs
echo "[2] Testing Connectivity to Other VMs..."
echo "----------------------------------------"

declare -A vms=(
    ["SIEM Server"]="192.168.56.10"
    ["Windows 7 VM"]="192.168.56.20"
    ["Kali Linux VM"]="192.168.56.30"
)

all_reachable=true

for vm_name in "${!vms[@]}"; do
    vm_ip="${vms[$vm_name]}"
    # Skip pinging self
    if [ "$CURRENT_IP" != "$vm_ip" ]; then
        echo -n "    Testing $vm_name ($vm_ip)... "
        if ping -c 2 -W 2 "$vm_ip" > /dev/null 2>&1; then
            echo "✓ REACHABLE"
        else
            echo "✗ UNREACHABLE"
            all_reachable=false
        fi
    fi
done

echo ""

# Verify Network Isolation (No Internet)
echo "[3] Verifying Network Isolation..."
echo "----------------------------------------"
echo -n "    Testing internet connectivity (should FAIL)... "
if ping -c 2 -W 2 8.8.8.8 > /dev/null 2>&1; then
    echo "⚠ WARNING: Internet accessible (isolation may be compromised)"
else
    echo "✓ No internet access (isolation verified)"
fi

echo ""

# Test Specific Ports
echo "[4] Testing Common Ports..."
echo "----------------------------------------"

if command -v nc &> /dev/null; then
    if [ "$CURRENT_IP" == "192.168.56.10" ]; then
        # SIEM Server - test SSH on other VMs
        echo -n "    Testing SSH on Kali Linux (192.168.56.30:22)... "
        if nc -zv -w 2 192.168.56.30 22 > /dev/null 2>&1; then
            echo "✓ OPEN"
        else
            echo "✗ CLOSED (or service not running)"
        fi
    elif [ "$CURRENT_IP" == "192.168.56.30" ]; then
        # Kali Linux - test SSH on SIEM
        echo -n "    Testing SSH on SIEM Server (192.168.56.10:22)... "
        if nc -zv -w 2 192.168.56.10 22 > /dev/null 2>&1; then
            echo "✓ OPEN"
        else
            echo "✗ CLOSED (or service not running)"
        fi
    fi
else
    echo "    ⚠ netcat (nc) not installed - skipping port tests"
    echo "      Install with: sudo apt install netcat"
fi

echo ""

# Summary
echo "========================================"
echo "Verification Summary"
echo "========================================"

if [ "$all_reachable" = true ] && [ -n "$CURRENT_IP" ]; then
    echo "✓ Network configuration appears correct"
    echo ""
    echo "Next Steps:"
    echo "  1. Verify static IPs on all VMs match expected values"
    echo "  2. Verify inter-VM connectivity from all VMs"
    echo "  3. Proceed to Phase 3: Log Collection"
else
    echo "✗ Network configuration issues detected"
    echo ""
    echo "Troubleshooting Steps:"
    echo "  1. Ensure all VMs are powered on"
    echo "  2. Verify VMware Network Editor configuration"
    echo "  3. Check static IP configuration on each VM"
    echo "  4. Verify firewall settings (ICMP may be blocked)"
    echo "     Ubuntu: sudo ufw allow icmp"
fi

echo ""

