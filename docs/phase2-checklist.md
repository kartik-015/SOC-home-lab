# Phase 2: Network Setup Checklist

Use this checklist during VM and network setup to ensure all steps are completed.

---

## Pre-Setup Prerequisites

- [ ] VMware Workstation Pro installed
- [ ] Ubuntu Server 20.04+ ISO downloaded
- [ ] Windows 7 SP1 ISO (or Windows 10 alternative) available
- [ ] Kali Linux ISO downloaded
- [ ] Administrator privileges on Windows 11 host
- [ ] Minimum 16GB RAM available on host

---

## Part 1: VMware Network Configuration

### Host-Only Network (VMnet1)

- [ ] Opened VMware Virtual Network Editor
- [ ] Selected VMnet1
- [ ] Set Subnet IP: `192.168.56.0`
- [ ] Set Subnet Mask: `255.255.255.0`
- [ ] Disabled DHCP service
- [ ] Applied settings
- [ ] Screenshot: Network Editor configuration
- [ ] Verified host adapter shows IP `192.168.56.1` (via `ipconfig`)

### NAT Network (VMnet8) - Optional

- [ ] Reviewed NAT network settings (optional, for updates)
- [ ] Verified NAT gateway IP: `192.168.100.2`
- [ ] Noted: NAT adapters will be DISABLED on all VMs by default

---

## Part 2: Virtual Machine Creation

### SIEM Server VM (Ubuntu)

**VM Creation:**
- [ ] Created new VM: `SOC-Lab-SIEM`
- [ ] Set memory: 4096 MB (4 GB)
- [ ] Set processors: 2 CPUs
- [ ] Set disk: 40 GB (thin provisioned)
- [ ] Network Adapter 1: Host-only (VMnet1) - CONNECTED
- [ ] Network Adapter 2: NAT (VMnet8) - NOT CONNECTED
- [ ] Screenshot: VM creation configuration

**Ubuntu Installation:**
- [ ] Installed Ubuntu Server 20.04+
- [ ] Created user: `socadmin` (or chosen username)
- [ ] Set hostname: `siem-server`
- [ ] Enabled OpenSSH server during installation
- [ ] Completed installation
- [ ] Screenshot: Installation completion

**Network Configuration:**
- [ ] Configured static IP: `192.168.56.10`
- [ ] Set subnet mask: `255.255.255.0`
- [ ] Set gateway: `192.168.56.1`
- [ ] Set DNS: `8.8.8.8, 8.8.4.4`
- [ ] Applied Netplan configuration
- [ ] Verified IP with `ip addr show`
- [ ] Screenshot: IP configuration verification

**Post-Installation:**
- [ ] Updated system: `sudo apt update && sudo apt upgrade -y`
- [ ] Installed essential tools (net-tools, curl, wget, vim, git)
- [ ] Verified network connectivity

---

### Windows 7 VM

**VM Creation:**
- [ ] Created new VM: `SOC-Lab-Windows7`
- [ ] Set memory: 2048 MB (2 GB)
- [ ] Set processors: 2 CPUs
- [ ] Set disk: 30 GB (thin provisioned)
- [ ] Network Adapter 1: Host-only (VMnet1) - CONNECTED
- [ ] Network Adapter 2: NAT (VMnet8) - NOT CONNECTED
- [ ] Screenshot: VM creation configuration

**Windows Installation:**
- [ ] Installed Windows 7 SP1 (or Windows 10)
- [ ] Completed initial setup
- [ ] Installed VMware Tools
- [ ] Screenshot: Windows desktop

**Network Configuration:**
- [ ] Configured static IP: `192.168.56.20`
- [ ] Set subnet mask: `255.255.255.0`
- [ ] Set gateway: `192.168.56.1`
- [ ] Set DNS: `8.8.8.8, 8.8.4.4`
- [ ] Verified IP with `ipconfig /all`
- [ ] Screenshot: IP configuration dialog
- [ ] Screenshot: `ipconfig /all` output

**Firewall Configuration:**
- [ ] Enabled ICMP (ping) in Windows Firewall
- [ ] Configured RDP (optional, for testing)

---

### Kali Linux VM

**VM Creation:**
- [ ] Created new VM: `SOC-Lab-Kali`
- [ ] Set memory: 2048 MB (2 GB)
- [ ] Set processors: 2 CPUs
- [ ] Set disk: 30 GB (thin provisioned)
- [ ] Network Adapter 1: Host-only (VMnet1) - CONNECTED
- [ ] Network Adapter 2: NAT (VMnet8) - NOT CONNECTED
- [ ] Screenshot: VM creation configuration

**Kali Installation:**
- [ ] Installed Kali Linux
- [ ] Completed initial setup
- [ ] Screenshot: Kali desktop

**Network Configuration:**
- [ ] Configured static IP: `192.168.56.30`
- [ ] Set subnet mask: `255.255.255.0`
- [ ] Set gateway: `192.168.56.1`
- [ ] Set DNS: `8.8.8.8, 8.8.4.4`
- [ ] Applied network configuration
- [ ] Verified IP with `ip addr show`
- [ ] Screenshot: Network configuration file
- [ ] Screenshot: IP verification

**Post-Installation:**
- [ ] Updated system (if internet available)
- [ ] Installed additional tools (if needed)

---

## Part 3: Network Connectivity Verification

### From Host Machine

- [ ] Verified VMnet1 adapter: `ipconfig` shows `192.168.56.1`
- [ ] Ping SIEM Server (`192.168.56.10`) - SUCCESS
- [ ] Ping Windows 7 (`192.168.56.20`) - SUCCESS
- [ ] Ping Kali Linux (`192.168.56.30`) - SUCCESS
- [ ] Screenshot: Host `ipconfig` output
- [ ] Screenshot: Successful pings from host

### From SIEM Server

- [ ] Ping Windows 7 (`192.168.56.20`) - SUCCESS
- [ ] Ping Kali Linux (`192.168.56.30`) - SUCCESS
- [ ] Test SSH to Kali (port 22) - SUCCESS (if SSH enabled)
- [ ] Screenshot: Ping results from SIEM

### From Windows 7

- [ ] Ping SIEM Server (`192.168.56.10`) - SUCCESS
- [ ] Ping Kali Linux (`192.168.56.30`) - SUCCESS
- [ ] Screenshot: Ping results from Windows 7

### From Kali Linux

- [ ] Ping SIEM Server (`192.168.56.10`) - SUCCESS
- [ ] Ping Windows 7 (`192.168.56.20`) - SUCCESS
- [ ] Test SSH to SIEM (port 22) - SUCCESS (if SSH enabled)
- [ ] Screenshot: Ping results from Kali

### Network Isolation Verification

- [ ] SIEM Server: Cannot ping `8.8.8.8` - FAILED (expected)
- [ ] Windows 7: Cannot ping `google.com` - FAILED (expected)
- [ ] Kali Linux: Cannot ping `8.8.8.8` - FAILED (expected)
- [ ] Screenshot: Failed internet pings (proving isolation)

---

## Part 4: Troubleshooting (if needed)

### Issues Encountered

- [ ] Issue: _________________________
- [ ] Resolution: _________________________

---

## Part 5: Final Validation

### Network Configuration Summary

| Component | Expected IP | Actual IP | Status |
|-----------|------------|-----------|--------|
| Host Machine | 192.168.56.1 | __________ | [ ] |
| SIEM Server | 192.168.56.10 | __________ | [ ] |
| Windows 7 VM | 192.168.56.20 | __________ | [ ] |
| Kali Linux VM | 192.168.56.30 | __________ | [ ] |

### Connectivity Matrix

| From → To | SIEM | Windows 7 | Kali | Status |
|-----------|------|-----------|------|--------|
| Host | [ ] | [ ] | [ ] | [ ] |
| SIEM | - | [ ] | [ ] | [ ] |
| Windows 7 | [ ] | - | [ ] | [ ] |
| Kali | [ ] | [ ] | - | [ ] |

---

## Screenshots Checklist

- [ ] VMware Virtual Network Editor (VMnet1 configuration)
- [ ] SIEM VM creation configuration
- [ ] SIEM network configuration file
- [ ] SIEM IP verification (`ip addr show`)
- [ ] Windows 7 VM creation configuration
- [ ] Windows 7 static IP configuration dialog
- [ ] Windows 7 IP verification (`ipconfig /all`)
- [ ] Kali VM creation configuration
- [ ] Kali network configuration file
- [ ] Kali IP verification
- [ ] Host `ipconfig` showing VMnet1
- [ ] Successful ping from SIEM to Windows 7
- [ ] Successful ping from SIEM to Kali
- [ ] Failed internet ping (isolation proof)

---

## Phase 2 Completion

- [ ] All VMs created and configured
- [ ] All static IPs assigned correctly
- [ ] Inter-VM connectivity verified
- [ ] Network isolation confirmed
- [ ] All screenshots captured
- [ ] Validation scripts tested (optional)

---

**Phase 2 Status**: ☐ **COMPLETE**

**Date Completed**: __________

**Notes**: 
___________________________________________________________________
___________________________________________________________________
___________________________________________________________________

---

**Ready for**: Phase 3 - Log Collection

