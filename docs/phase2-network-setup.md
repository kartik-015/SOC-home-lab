# PHASE 2: VM & Network Setup

## Overview

This phase configures VMware Workstation networking to create a secure, isolated lab environment. We'll set up host-only networking for inter-VM communication and optional NAT networking for software updates.

---

## Objectives

1. ✅ Configure VMware host-only network
2. ✅ Create and configure three VMs (SIEM, Windows 7, Kali Linux)
3. ✅ Assign static IP addresses
4. ✅ Verify inter-VM connectivity
5. ✅ Validate network isolation

---

## Prerequisites

Before starting, ensure you have:

- [ ] VMware Workstation Pro installed (Version 15+ recommended)
- [ ] Ubuntu Server 20.04 LTS ISO downloaded
- [ ] Windows 7 SP1 ISO (or Windows 10 if Windows 7 unavailable)
- [ ] Kali Linux ISO (Latest version)
- [ ] Administrator privileges on Windows 11 host
- [ ] Minimum 16GB RAM on host machine (8GB usable for VMs)

**Note**: Windows 7 is end-of-life. If unavailable, Windows 10 can be used as an alternative.

---

## Part 1: VMware Network Configuration

### Step 1.1: Access VMware Network Editor

1. Open **VMware Workstation Pro**
2. Go to **Edit** → **Virtual Network Editor**
3. Click **Change Settings** (Administrator privileges required)
4. You'll see default virtual networks: VMnet0, VMnet1, VMnet8

### Step 1.2: Configure Host-Only Network (VMnet1)

**Configuration Steps:**

1. Select **VMnet1** from the list
2. Ensure **Type** is set to **Host-only**
3. Click **Subnet settings**
4. Configure:
   - **Subnet IP**: `192.168.56.0`
   - **Subnet mask**: `255.255.255.0`
5. Click **Apply**

**Host Adapter Settings:**

1. Ensure **Connect a host virtual adapter to this network** is **CHECKED**
2. Host IP will be: `192.168.56.1` (auto-assigned)
3. Click **DHCP Settings** (we won't use DHCP, but verify it's disabled)
4. Uncheck **Use local DHCP service to distribute IP addresses to VMs**
5. Click **OK** to close DHCP settings
6. Click **OK** to save network settings

**Screenshot Checklist:**
- [ ] Virtual Network Editor main window showing VMnet1 configured
- [ ] Subnet settings showing 192.168.56.0/255.255.255.0
- [ ] DHCP settings disabled

### Step 1.3: Configure NAT Network (VMnet8) - Optional

**When to use:** Only enable when you need internet access for downloads/updates.

**Configuration Steps:**

1. Select **VMnet8** from the list
2. Ensure **Type** is set to **NAT**
3. Click **NAT Settings**
4. Verify Gateway IP: `192.168.100.2` (default, can be changed)
5. Click **Cancel** to close NAT settings
6. Click **Subnet settings**
7. Verify:
   - **Subnet IP**: `192.168.100.0`
   - **Subnet mask**: `255.255.255.0`
8. Click **Apply** and **OK**

**Important**: Disable NAT adapter on VMs when not needed to maintain isolation.

---

## Part 2: Virtual Machine Creation

### Step 2.1: Create SIEM Server VM (Ubuntu)

**VM Specifications:**

| Setting | Value |
|---------|-------|
| **Name** | `SOC-Lab-SIEM` |
| **Guest OS** | Linux → Ubuntu 64-bit |
| **Memory** | 4096 MB (4 GB) |
| **Processors** | 2 CPUs |
| **Hard Disk** | 40 GB (SCSI, thin provisioned) |
| **Network Adapter 1** | Host-only (VMnet1) |
| **Network Adapter 2** | NAT (VMnet8) - **DISABLED by default** |

**Creation Steps:**

1. In VMware Workstation, click **File** → **New Virtual Machine**
2. Select **Typical** configuration → **Next**
3. Select **I will install the operating system later** → **Next**
4. Select **Linux** → **Ubuntu 64-bit** → **Next**
5. Name: `SOC-Lab-SIEM`
6. Location: Choose your VMs directory → **Next**
7. Maximum disk size: **40 GB** → Select **Split virtual disk into multiple files** → **Next**
8. Click **Customize Hardware**
   - **Memory**: 4096 MB
   - **Processors**: 2
   - **New CD/DVD**: Use ISO image file → Browse to Ubuntu Server ISO
   - **Network Adapter**: Select **Host-only (VMnet1)**
   - **Add** → **Network Adapter** → Select **NAT (VMnet8)** → Check **Don't connect** to disable
9. Click **Close** → **Finish**

**Installation Steps (Ubuntu Server):**

1. Power on the VM
2. Boot from ISO and follow Ubuntu Server installation:
   - Language: English
   - Keyboard: Default
   - Network: Configure static IP (see Step 2.2)
   - Username: `socadmin` (or your choice)
   - Hostname: `siem-server`
   - Enable **OpenSSH server** during installation
   - Install security updates automatically: **Yes**
3. Complete installation and reboot

**Post-Installation:**

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install -y net-tools curl wget vim git

# Verify network configuration
ip addr show
```

**Screenshot Checklist:**
- [ ] VM creation wizard showing SIEM VM configuration
- [ ] Network adapter settings (Host-only enabled, NAT disabled)
- [ ] Ubuntu installation completion

### Step 2.2: Configure Static IP on SIEM Server

**Network Configuration:**

Edit the Netplan configuration file:

```bash
sudo vim /etc/netplan/00-installer-config.yaml
```

**Configuration File Content:**

```yaml
network:
  version: 2
  ethernets:
    ens33:  # Primary adapter name (check with: ip link show)
      dhcp4: no
      addresses:
        - 192.168.56.10/24
      gateway4: 192.168.56.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
```

**Note**: Adapter name may vary (`ens33`, `eth0`, `enp0s3`). Check with `ip link show`.

**Apply Configuration:**

```bash
# Validate configuration
sudo netplan try

# Apply configuration (if try succeeded)
sudo netplan apply

# Verify IP assignment
ip addr show ens33
```

**Expected Output:**
```
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:xx:xx:xx brd ff:ff:ff:ff:ff:ff
    inet 192.168.56.10/24 brd 192.168.56.255 scope global noprefixroute ens33
       valid_lft forever preferred_lft forever
```

**Screenshot Checklist:**
- [ ] Netplan configuration file contents
- [ ] IP address verification (`ip addr show`)

### Step 2.3: Create Windows 7 VM

**VM Specifications:**

| Setting | Value |
|---------|-------|
| **Name** | `SOC-Lab-Windows7` |
| **Guest OS** | Microsoft Windows → Windows 7 x64 |
| **Memory** | 2048 MB (2 GB) |
| **Processors** | 2 CPUs |
| **Hard Disk** | 30 GB (SCSI, thin provisioned) |
| **Network Adapter 1** | Host-only (VMnet1) |
| **Network Adapter 2** | NAT (VMnet8) - **DISABLED** |

**Creation Steps:**

1. **File** → **New Virtual Machine**
2. Select **Typical** → **Next**
3. **I will install the operating system later** → **Next**
4. **Microsoft Windows** → **Windows 7 x64** → **Next**
5. Name: `SOC-Lab-Windows7` → **Next**
6. Disk: 30 GB, split files → **Next**
7. **Customize Hardware**:
   - **Memory**: 2048 MB
   - **Processors**: 2
   - **CD/DVD**: Windows 7 ISO
   - **Network Adapter**: Host-only (VMnet1)
   - **Add Network Adapter**: NAT (VMnet8) → **Don't connect**
8. **Finish**

**Windows 7 Installation:**

1. Power on VM and install Windows 7
2. During installation, configure static IP (or configure after installation)

**Configure Static IP (Windows 7):**

1. Right-click **Network** icon → **Open Network and Sharing Center**
2. Click **Change adapter settings**
3. Right-click **Local Area Connection** → **Properties**
4. Select **Internet Protocol Version 4 (TCP/IPv4)** → **Properties**
5. Configure:
   - **Use the following IP address:**
     - IP address: `192.168.56.20`
     - Subnet mask: `255.255.255.0`
     - Default gateway: `192.168.56.1`
   - **Use the following DNS server addresses:**
     - Preferred: `8.8.8.8`
     - Alternate: `8.8.4.4`
6. Click **OK** → **OK**

**Verify IP Configuration:**

Open Command Prompt (cmd.exe) and run:

```cmd
ipconfig /all
```

**Expected Output:**
```
Ethernet adapter Local Area Connection:
   Connection-specific DNS Suffix  . :
   IPv4 Address. . . . . . . . . . . : 192.168.56.20
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 192.168.56.1
```

**Post-Installation:**

- Install VMware Tools for better performance
- Enable Remote Desktop (if needed for testing)
- Configure Windows Firewall (allow ICMP for ping)

**Screenshot Checklist:**
- [ ] Windows 7 VM creation configuration
- [ ] Static IP configuration dialog
- [ ] `ipconfig /all` output

### Step 2.4: Create Kali Linux VM

**VM Specifications:**

| Setting | Value |
|---------|-------|
| **Name** | `SOC-Lab-Kali` |
| **Guest OS** | Linux → Debian 11.x 64-bit |
| **Memory** | 2048 MB (2 GB) |
| **Processors** | 2 CPUs |
| **Hard Disk** | 30 GB (SCSI, thin provisioned) |
| **Network Adapter 1** | Host-only (VMnet1) |
| **Network Adapter 2** | NAT (VMnet8) - **DISABLED** |

**Creation Steps:**

1. **File** → **New Virtual Machine**
2. **Typical** → **Next**
3. **I will install the operating system later** → **Next**
4. **Linux** → **Debian 11.x 64-bit** → **Next**
5. Name: `SOC-Lab-Kali` → **Next**
6. Disk: 30 GB, split files → **Next**
7. **Customize Hardware**:
   - **Memory**: 2048 MB
   - **Processors**: 2
   - **CD/DVD**: Kali Linux ISO
   - **Network Adapter**: Host-only (VMnet1)
   - **Add Network Adapter**: NAT (VMnet8) → **Don't connect**
8. **Finish**

**Kali Linux Installation:**

1. Power on VM and install Kali Linux
2. During installation, use DHCP initially (we'll set static IP after)

**Configure Static IP (Kali Linux):**

Edit network interfaces:

```bash
sudo vim /etc/network/interfaces
```

**Configuration:**

```
auto eth0
iface eth0 inet static
    address 192.168.56.30
    netmask 255.255.255.0
    gateway 192.168.56.1
    dns-nameservers 8.8.8.8 8.8.4.4
```

**Apply Configuration:**

```bash
# Restart networking
sudo systemctl restart networking

# Or use ifdown/ifup
sudo ifdown eth0 && sudo ifup eth0

# Verify
ip addr show eth0
```

**Alternative (Netplan on newer Kali):**

```bash
sudo vim /etc/netplan/00-installer-config.yaml
```

```yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: no
      addresses:
        - 192.168.56.30/24
      gateway4: 192.168.56.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
```

```bash
sudo netplan apply
```

**Screenshot Checklist:**
- [ ] Kali Linux VM creation configuration
- [ ] Network configuration file
- [ ] IP address verification

---

## Part 3: Network Connectivity Verification

### Step 3.1: Verify Host-Only Network from Host

**From Windows 11 Host (PowerShell or CMD):**

```cmd
ipconfig
```

Look for adapter with IP `192.168.56.1`

**Expected Output:**
```
Ethernet adapter VMware Network Adapter VMnet1:
   IPv4 Address. . . . . . . . . . . : 192.168.56.1
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
```

**Test Connectivity:**

```cmd
ping 192.168.56.10
ping 192.168.56.20
ping 192.168.56.30
```

All should respond (once VMs are powered on).

### Step 3.2: Verify Inter-VM Connectivity

**Test 1: SIEM Server to Windows 7**

From SIEM Server (Ubuntu):

```bash
# Ping Windows 7
ping -c 4 192.168.56.20

# Test TCP connectivity (if RDP enabled)
telnet 192.168.56.20 3389
# Or
nc -zv 192.168.56.20 3389
```

**Expected Output:**
```
PING 192.168.56.20 (192.168.56.20) 56(84) bytes of data.
64 bytes from 192.168.56.20: icmp_seq=1 ttl=128 time=0.XXX ms
...
--- 192.168.56.20 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss
```

**Test 2: SIEM Server to Kali Linux**

From SIEM Server:

```bash
# Ping Kali
ping -c 4 192.168.56.30

# Test SSH connectivity
nc -zv 192.168.56.30 22
```

**Test 3: Windows 7 to SIEM Server**

From Windows 7 (Command Prompt):

```cmd
ping 192.168.56.10
```

**Test 4: Windows 7 to Kali Linux**

From Windows 7:

```cmd
ping 192.168.56.30
```

**Test 5: Kali Linux to SIEM Server**

From Kali Linux:

```bash
ping -c 4 192.168.56.10
nc -zv 192.168.56.10 22
```

**Test 6: Kali Linux to Windows 7**

From Kali Linux:

```bash
ping -c 4 192.168.56.20
nc -zv 192.168.56.20 3389
```

### Step 3.3: Verify Network Isolation

**Test Internet Connectivity (Should FAIL on Host-Only):**

From each VM:

```bash
# SIEM Server
ping -c 2 8.8.8.8

# Kali Linux
ping -c 2 google.com

# Windows 7
ping 8.8.8.8
```

**Expected Result:** All should **FAIL** or timeout (proving isolation).

**Screenshot Checklist:**
- [ ] Host `ipconfig` showing VMnet1 adapter
- [ ] Successful ping from SIEM to Windows 7
- [ ] Successful ping from SIEM to Kali
- [ ] Failed internet ping (proving isolation)

---

## Part 4: Network Troubleshooting

### Common Issues and Solutions

#### Issue 1: VMs Cannot Ping Each Other

**Possible Causes:**
- Firewall blocking ICMP
- Wrong network adapter selected
- IP address misconfiguration

**Solution:**

1. **Check Network Adapter:**
   - Ensure all VMs use **Host-only (VMnet1)**
   - In VM → Settings → Network Adapter → Verify selection

2. **Check Firewall (Windows 7):**
   ```cmd
   # Enable ICMP (allow ping)
   netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow
   ```

3. **Check Firewall (Ubuntu/Kali):**
   ```bash
   # Ubuntu (UFW)
   sudo ufw allow icmp
   sudo ufw status
   
   # Or disable firewall temporarily for testing
   sudo ufw disable
   ```

4. **Verify IP Configuration:**
   ```bash
   # Linux
   ip addr show
   
   # Windows
   ipconfig /all
   ```

#### Issue 2: Cannot Access VMs from Host

**Solution:**

1. Verify VMnet1 is connected on host:
   ```cmd
   ipconfig
   # Should show 192.168.56.1
   ```

2. Verify VMs are powered on

3. Verify network adapter is connected in VM settings

#### Issue 3: IP Address Not Assigning

**Solution:**

1. **Linux (Netplan):**
   ```bash
   # Check adapter name
   ip link show
   
   # Validate configuration
   sudo netplan try
   
   # View logs
   sudo journalctl -u netplan -n 50
   ```

2. **Windows:**
   - Release and renew IP:
   ```cmd
   ipconfig /release
   ipconfig /renew
   ```
   - Or manually configure in Network and Sharing Center

---

## Part 5: Network Security Validation

### Security Checklist

- [ ] **Host-Only Network Active**: All VMs on VMnet1
- [ ] **NAT Disabled**: NAT adapters disconnected on all VMs
- [ ] **No Internet Access**: Cannot ping external IPs (8.8.8.8)
- [ ] **Static IPs Assigned**: All VMs have correct static IPs
- [ ] **Inter-VM Communication**: All VMs can ping each other
- [ ] **Host Access**: Host can ping all VMs
- [ ] **Firewall Configured**: Firewalls enabled on all VMs (will configure later)

---

## Part 6: Network Configuration Summary

### IP Addressing Scheme

| Component | IP Address | MAC Address | Adapter |
|-----------|-----------|-------------|---------|
| **Host Machine** | 192.168.56.1 | Auto | VMnet1 |
| **SIEM Server** | 192.168.56.10 | Check VM | ens33/eth0 |
| **Windows 7 VM** | 192.168.56.20 | Check VM | Local Area Connection |
| **Kali Linux VM** | 192.168.56.30 | Check VM | eth0 |

### Network Configuration Files

Save these for reference:

**SIEM Server (Ubuntu):** `/etc/netplan/00-installer-config.yaml`
**Windows 7:** Network Adapter Properties (screenshot)
**Kali Linux:** `/etc/network/interfaces` or `/etc/netplan/00-installer-config.yaml`

---

## Validation Checklist

- [ ] VMware Network Editor configured (VMnet1: 192.168.56.0/24)
- [ ] SIEM Server VM created and Ubuntu installed
- [ ] Windows 7 VM created and Windows installed
- [ ] Kali Linux VM created and Kali installed
- [ ] Static IPs configured on all VMs:
  - [ ] SIEM: 192.168.56.10
  - [ ] Windows 7: 192.168.56.20
  - [ ] Kali: 192.168.56.30
- [ ] Inter-VM connectivity verified (ping successful)
- [ ] Host can ping all VMs
- [ ] Network isolation verified (no internet access)
- [ ] All screenshots captured

---

## Next Steps

**Phase 2 Status**: ✅ **COMPLETE**

**Ready for**: Phase 3 - Log Collection

Phase 3 will cover:
- Installing Wazuh agent on Windows 7
- Installing Wazuh Manager on SIEM Server
- Configuring Sysmon on Windows 7
- Setting up rsyslog on Kali Linux
- Validating log forwarding

---

## Screenshots Required

Capture screenshots of:

1. [ ] VMware Virtual Network Editor showing VMnet1 configuration
2. [ ] VM creation wizard for SIEM Server
3. [ ] SIEM Server network configuration (Netplan file)
4. [ ] SIEM Server IP verification (`ip addr show`)
5. [ ] Windows 7 static IP configuration dialog
6. [ ] Windows 7 IP verification (`ipconfig /all`)
7. [ ] Kali Linux network configuration file
8. [ ] Kali Linux IP verification
9. [ ] Successful ping from SIEM to Windows 7
10. [ ] Successful ping from SIEM to Kali
11. [ ] Failed internet ping (proving isolation)
12. [ ] Host `ipconfig` showing VMnet1 adapter

---

**Phase 2 Documentation Complete**

