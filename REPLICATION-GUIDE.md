# 🔧 SOC Home Lab - Replication Guide

## Want to Build This Lab Yourself?

This guide will help you replicate this SOC home lab on your own system. Perfect for cybersecurity students, aspiring SOC analysts, or anyone wanting hands-on SIEM experience.

---

## 📋 Prerequisites

### Hardware Requirements (Minimum)
- **CPU:** 4+ cores (8+ cores recommended)
- **RAM:** 16GB minimum (24GB+ recommended)
- **Storage:** 100GB free disk space
- **OS:** Windows 10/11 (for VMware host) or Linux with virtualization support

**Why these specs?**
- Ubuntu Server: 8GB RAM, 4 cores, 60GB disk
- Windows 10: 4GB RAM, 2 cores, 40GB disk
- Kali Linux: 2GB RAM, 2 cores, 20GB disk
- Host overhead: 2GB RAM

### Software Requirements
- **VMware Workstation Pro** (or VMware Player - free)
  - Alternative: VirtualBox (free, but some steps will differ)
- **ISO Images:**
  - Ubuntu Server 24.04 LTS ([Download](https://ubuntu.com/download/server))
  - Windows 10 Pro ([Download](https://www.microsoft.com/software-download/windows10))
  - Kali Linux ([Download](https://www.kali.org/get-kali/))

### Knowledge Prerequisites
- Basic Linux command line (apt, systemctl, nano/vim)
- Basic Windows administration (PowerShell, services)
- Basic networking concepts (IP addressing, subnets, gateways)
- Willingness to troubleshoot and Google errors 😊

---

## 🚀 Step-by-Step Setup Guide

### Phase 1: Virtual Machine Creation (1-2 hours)

#### 1.1 Create Ubuntu Server VM
```
Name: SOC-Ubuntu-Server
OS: Ubuntu 64-bit
RAM: 8GB (8192 MB)
Processors: 4 cores
Hard Disk: 60GB (thin provisioned)
Network Adapter 1: Host-only (for management)
Network Adapter 2: NAT (for internet access)
```

**Installation:**
1. Boot from Ubuntu Server 24.04 ISO
2. Choose language: English
3. Network: Accept defaults (will configure later)
4. Storage: Use entire disk
5. Profile: 
   - Name: Your name
   - Server name: `siemserver`
   - Username: `kartik` (or your choice)
   - Password: Create strong password
6. Install OpenSSH server: **YES**
7. No featured snaps needed
8. Complete installation and reboot

#### 1.2 Create Windows 10 VM
```
Name: SOC-Windows10-Victim
OS: Windows 10 x64
RAM: 4GB (4096 MB)
Processors: 2 cores
Hard Disk: 40GB (thin provisioned)
Network Adapter: Host-only (same network as Ubuntu)
```

**Installation:**
1. Boot from Windows 10 ISO
2. Edition: Windows 10 Pro
3. Custom installation
4. Create local account (not Microsoft account)
5. Disable privacy settings
6. Complete installation

#### 1.3 Create Kali Linux VM
```
Name: SOC-Kali-Attacker
OS: Debian 64-bit
RAM: 2GB (2048 MB)
Processors: 2 cores
Hard Disk: 20GB (thin provisioned)
Network Adapter: Host-only (same network as others)
```

**Installation:**
1. Boot from Kali Linux ISO
2. Graphical install
3. Create user and password
4. Install XFCE desktop environment
5. Complete installation

---

### Phase 2: Network Configuration (30 minutes)

#### 2.1 Windows Host - Enable Internet Connection Sharing (ICS)

**On your Windows 11/10 host:**
1. Open **Network Connections** (`ncpa.cpl`)
2. Right-click your **Ethernet/WiFi** adapter (the one with internet)
3. Properties → Sharing tab
4. ✅ Check "Allow other network users to connect"
5. Select **VMnet1** (Host-only adapter) from dropdown
6. Click OK

**Result:** Your VMs will get internet through ICS
**Network will be:** 192.168.137.0/24
**Gateway:** 192.168.137.1 (your Windows host)

#### 2.2 Ubuntu Server - Configure Static IP

**SSH into Ubuntu or use VM console:**

```bash
# Edit network configuration
sudo nano /etc/netplan/50-cloud-init.yaml
```

**Replace with:**
```yaml
network:
  version: 2
  ethernets:
    ens33:
      addresses:
        - 192.168.137.10/24
      routes:
        - to: default
          via: 192.168.137.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
    ens34:
      dhcp4: false
```

**Apply configuration:**
```bash
sudo netplan apply
ip addr show  # Verify IP is 192.168.137.10
ping 8.8.8.8  # Test internet connectivity
```

#### 2.3 Windows 10 - Configure Static IP

**On Windows 10 VM:**
1. Open **Network Connections**
2. Right-click Ethernet adapter → Properties
3. Select **Internet Protocol Version 4 (TCP/IPv4)**
4. Click Properties
5. Use the following IP address:
   - IP: `192.168.137.20`
   - Subnet: `255.255.255.0`
   - Gateway: `192.168.137.1`
   - DNS: `8.8.8.8`
6. Click OK

**Test:**
```powershell
ping 192.168.137.10  # Should reach Ubuntu
ping 8.8.8.8  # Should reach internet
```

#### 2.4 Kali Linux - Configure Static IP

**Edit network configuration:**
```bash
sudo nano /etc/network/interfaces
```

**Add:**
```
auto eth0
iface eth0 inet static
    address 192.168.137.30
    netmask 255.255.255.0
    gateway 192.168.137.1
    dns-nameservers 8.8.8.8
```

**Apply:**
```bash
sudo systemctl restart networking
ip addr show
ping 192.168.137.10  # Test Ubuntu
```

---

### Phase 3: Wazuh SIEM Installation (30-45 minutes)

#### 3.1 Download Wazuh Installer

**On Ubuntu Server:**
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Download Wazuh installation script
curl -sO https://packages.wazuh.com/4.14/wazuh-install.sh

# Verify script downloaded
ls -lh wazuh-install.sh
```

#### 3.2 Run All-in-One Installation

**This installs Manager + Indexer + Dashboard:**
```bash
# Make script executable
chmod +x wazuh-install.sh

# Run installation (takes 10-15 minutes)
sudo bash ./wazuh-install.sh -a
```

**What this does:**
- Installs Wazuh Manager (analysis engine)
- Installs Wazuh Indexer (OpenSearch for storage)
- Installs Wazuh Dashboard (web interface)
- Generates SSL certificates
- Creates random admin password

#### 3.3 Save Your Credentials

**Extract password:**
```bash
# Create backup of installation files
sudo tar -xvf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt -O | grep "admin"
```

**Save the password!** You'll need it for dashboard login.

**Example output:**
```
User: admin
Password: Zr+vAGD3Wm2E.?0odXtlS0QgfuzGuQiP
```

#### 3.4 Verify Services

```bash
# Check all services are running
sudo systemctl status wazuh-manager
sudo systemctl status wazuh-indexer
sudo systemctl status wazuh-dashboard

# Should all show "active (running)"
```

#### 3.5 Access Dashboard

**From your host machine browser:**
1. Navigate to: `https://192.168.137.10`
2. Accept SSL certificate warning (self-signed cert)
3. Login:
   - Username: `admin`
   - Password: (from step 3.3)
4. You should see the Wazuh dashboard!

---

### Phase 4: Windows Agent Deployment (30 minutes)

#### 4.1 Download Wazuh Agent

**On Windows 10 VM:**
1. Open browser, go to: `https://192.168.137.10`
2. Login to dashboard
3. Click hamburger menu → **Agents**
4. Click **Deploy new agent**
5. Select:
   - OS: **Windows**
   - Server address: `192.168.137.10`
6. Copy the download command OR download MSI manually

**Alternative - Direct download:**
```powershell
# In PowerShell as Administrator
$url = "https://packages.wazuh.com/4.x/windows/wazuh-agent-4.8.0-1.msi"
$output = "C:\Users\Public\wazuh-agent.msi"
Invoke-WebRequest -Uri $url -OutFile $output
```

#### 4.2 Install Agent

**Run in PowerShell as Administrator:**
```powershell
msiexec.exe /i C:\Users\Public\wazuh-agent.msi /q WAZUH_MANAGER="192.168.137.10" WAZUH_AGENT_NAME="windows10-victim"
```

#### 4.3 Register Agent Manually

**On Ubuntu Server:**
```bash
# Add agent
sudo /var/ossec/bin/manage_agents

# Press: a (add agent)
# Name: windows10-victim
# IP: 192.168.137.20
# ID: (accept default 001)

# Press: e (extract key)
# Agent ID: 001
# Copy the key shown (long base64 string)
```

**On Windows 10:**
```powershell
# Import key
cd "C:\Program Files (x86)\ossec-agent"
.\manage_agents.exe -i YOUR_KEY_HERE
```

#### 4.4 Start Agent

```powershell
# Start Wazuh service
Start-Service -Name wazuh

# Check status
Get-Service -Name wazuh
```

#### 4.5 Verify Connection

**On Ubuntu:**
```bash
# Check agent status
sudo /var/ossec/bin/agent_control -l

# Should show:
# ID: 001, Name: windows10-victim, IP: 192.168.137.20, Status: Active
```

**In Dashboard:**
1. Go to **Agents** module
2. You should see **windows10-victim** with green "Active" status

---

### Phase 5: Sysmon Installation (15 minutes)

#### 5.1 Download Sysmon

**On Windows 10:**
1. Download from: https://docs.microsoft.com/sysinternals/downloads/sysmon
2. Extract to: `C:\Sysmon`

#### 5.2 Download Configuration

**Download SwiftOnSecurity config:**
```powershell
# In PowerShell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml" -OutFile "C:\sysmonconfig.xml"
```

#### 5.3 Install Sysmon

```powershell
# Run as Administrator
cd C:\Sysmon
.\Sysmon64.exe -accepteula -i C:\sysmonconfig.xml
```

**Verify:**
```powershell
Get-Service -Name Sysmon64
# Should show "Running"
```

#### 5.4 Configure Wazuh to Collect Sysmon

**Edit agent config:**
```powershell
notepad "C:\Program Files (x86)\ossec-agent\ossec.conf"
```

**Find the `<localfile>` section and ADD this:**
```xml
  <localfile>
    <location>Microsoft-Windows-Sysmon/Operational</location>
    <log_format>eventchannel</log_format>
  </localfile>
```

**Save and restart agent:**
```powershell
Restart-Service -Name wazuh
```

#### 5.5 Verify Sysmon Logs in Wazuh

**Wait 2-3 minutes, then on Ubuntu:**
```bash
# Check for Sysmon events
sudo grep -i "sysmon" /var/ossec/logs/alerts/alerts.json | tail -5
```

**In Dashboard:**
- Go to **Discover**
- Filter: `rule.groups: "sysmon"`
- You should see Sysmon events!

---

### Phase 6: Test with Attack Simulations (30 minutes)

#### 6.1 Attack 1: Encoded PowerShell

**On Windows 10:**
```powershell
powershell.exe -EncodedCommand "dwBoAG8AYQBtAGkA"
```

**Expected Detection:** Rule 92057, Level 12 (HIGH)

#### 6.2 Attack 2: EICAR Malware Test

```powershell
'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' | Out-File C:\Users\Public\eicar.txt -Encoding ASCII
```

**Expected Detection:** Sysmon Event ID 11 (File Creation)

#### 6.3 Attack 3: Account Discovery

```powershell
net user Administrator
net localgroup Administrators
whoami /priv
```

**Expected Detection:** net.exe discovery commands

#### 6.4 Attack 4: Network Scan (from Kali)

**On Kali Linux:**
```bash
nmap -sS -p 1-1000 192.168.137.20 -Pn
```

**Expected Detection:** Network scanning activity

#### 6.5 Verify Alerts

**In Dashboard:**
1. Go to **Discover**
2. Time: Last 15 minutes
3. Filter: `agent.name: "windows10-victim"`
4. Look for high-severity alerts (Level ≥7)

**On Ubuntu command line:**
```bash
# View recent alerts
sudo tail -50 /var/ossec/logs/alerts/alerts.json | jq -r '.rule.description' | sort | uniq
```

---

## 🎯 Expected Results

After completing all phases, you should have:

✅ **3 VMs running** on 192.168.137.0/24 network
✅ **Wazuh Dashboard** accessible at https://192.168.137.10
✅ **1 Active agent** (Windows 10) shown in dashboard
✅ **Sysmon events** appearing in logs
✅ **Attack simulations detected** with high-severity alerts
✅ **MITRE ATT&CK** techniques mapped (T1059.001, T1087)

---

## 🐛 Common Issues & Solutions

### Issue 1: VMs Can't Access Internet
**Symptom:** `ping 8.8.8.8` fails on Ubuntu

**Solution:**
- Verify ICS is enabled on Windows host
- Check gateway is 192.168.137.1
- Verify DNS is set to 8.8.8.8
- Run `ip route` on Ubuntu to check default route

### Issue 2: Agent Shows "Never Connected"
**Symptom:** Agent status is disconnected in dashboard

**Solution:**
```powershell
# On Windows, check ossec.conf
notepad "C:\Program Files (x86)\ossec-agent\ossec.conf"

# Verify <address> matches Ubuntu IP
<server>
  <address>192.168.137.10</address>
  <port>1514</port>
  ...
</server>

# Restart agent
Restart-Service -Name wazuh
```

### Issue 3: Sysmon Logs Not Appearing
**Symptom:** No Sysmon events in dashboard

**Solution:**
```powershell
# Verify Sysmon is running
Get-Service -Name Sysmon64

# Check Sysmon is generating events
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -MaxEvents 5

# Verify log format is "eventchannel" (NOT "eventlog")
notepad "C:\Program Files (x86)\ossec-agent\ossec.conf"

# Should be:
# <log_format>eventchannel</log_format>
```

### Issue 4: Dashboard Certificate Error
**Symptom:** Browser blocks access to dashboard

**Solution:**
- This is expected (self-signed certificate)
- Click "Advanced" → "Proceed to 192.168.137.10"
- Or use: `thisisunsafe` keyboard shortcut in Chrome

### Issue 5: Low RAM / System Slow
**Symptom:** VMs are laggy or freezing

**Solution:**
- Close unnecessary applications on host
- Reduce Ubuntu RAM to 6GB if needed (minimum)
- Pause Kali when not in use
- Consider upgrading host RAM

---

## 📚 Additional Resources

### Official Documentation
- [Wazuh Installation Guide](https://documentation.wazuh.com/current/installation-guide/)
- [Wazuh Agent Deployment](https://documentation.wazuh.com/current/installation-guide/wazuh-agent/)
- [Sysmon Documentation](https://docs.microsoft.com/sysinternals/downloads/sysmon)

### Configurations
- [SwiftOnSecurity Sysmon Config](https://github.com/SwiftOnSecurity/sysmon-config)
- [Wazuh Rules Reference](https://documentation.wazuh.com/current/user-manual/ruleset/)

### Learning Resources
- [MITRE ATT&CK Framework](https://attack.mitre.org/)
- [Wazuh Use Cases](https://documentation.wazuh.com/current/proof-of-concept-guide/)
- [SOC Analyst Roadmap](https://roadmap.sh/cyber-security)

---

## 🎓 What You'll Learn

By completing this lab, you'll gain hands-on experience with:

✅ SIEM deployment and configuration
✅ Security agent management
✅ Enhanced Windows logging with Sysmon
✅ Threat detection and alert analysis
✅ MITRE ATT&CK framework mapping
✅ Network design for security labs
✅ Attack simulation and validation
✅ Log correlation and threat hunting

---

## 🤝 Need Help?

- **GitHub Issues:** Open an issue in this repository
- **Wazuh Community:** https://groups.google.com/forum/#!forum/wazuh
- **Discord/Slack:** Join cybersecurity communities
- **Documentation:** Always check official Wazuh docs first

---

## ⚠️ Important Notes

**Ethical Use:**
- This lab is for **educational purposes only**
- Only perform attacks on **your own isolated lab environment**
- Never use these techniques on systems you don't own
- Understand local laws regarding security testing

**System Performance:**
- Expect host system slowdown with 3 VMs running
- SSD storage highly recommended
- Close VMs when not in use to free resources

**Time Investment:**
- Initial setup: 3-5 hours
- Learning the system: 10-20 hours
- Mastery: Ongoing practice

---

## 🌟 Next Steps After Setup

1. **Explore More Attacks:**
   - Brute force with Hydra
   - Mimikatz credential dumping
   - Lateral movement techniques

2. **Create Custom Rules:**
   - Edit `/var/ossec/etc/rules/local_rules.xml`
   - Build frequency-based detections

3. **Build Dashboards:**
   - Create custom visualizations
   - Set up automated reports

4. **Document Your Findings:**
   - Take screenshots
   - Write incident reports
   - Build a portfolio

---

**Good luck building your SOC lab! 🚀**

**Questions? Open an issue on GitHub or tag me on LinkedIn.**

**Star ⭐ this repo if you found it helpful!**
