# SOC Home Lab - Wazuh SIEM Implementation

## 🎯 Project Overview

Built a fully functional Security Operations Center (SOC) home lab featuring Wazuh SIEM for real-time threat detection, log analysis, and incident response. The lab simulates enterprise security monitoring with multi-system telemetry collection and MITRE ATT&CK framework mapping.

**Project Status:** ✅ Operational  
**Duration:** January 10-12, 2026  
**Complexity:** Intermediate to Advanced

---

## 🏗️ Architecture

### Network Topology
- **Network:** 192.168.137.0/24 (Windows 11 Internet Connection Sharing)
- **Gateway:** 192.168.137.1 (Windows 11 Host)

### System Components

| System | IP Address | Role | Specifications |
|--------|------------|------|----------------|
| Ubuntu Server 24.04 | 192.168.137.10 | Wazuh SIEM Server | 14.9GB RAM, 12 CPU cores, 60GB disk |
| Windows 10 Pro | 192.168.137.20 | Victim/Monitored Endpoint | Wazuh Agent + Sysmon 15.15 |
| Kali Linux | 192.168.137.30 | Attack Simulation Platform | Nmap, Hydra, Metasploit |
| Windows 11 | Host System | Virtualization Host | VMware Workstation |

### Wazuh Components
- **Wazuh Manager 4.14.1:** Central analysis engine
- **Wazuh Indexer:** OpenSearch-based log storage
- **Wazuh Dashboard:** Web-based visualization and analysis interface
- **Wazuh Agent 4.8.0:** Endpoint telemetry collection

---

## 🛠️ Technologies & Tools

### Security Monitoring
- **Wazuh SIEM 4.14.1** - Security Information and Event Management
- **Sysmon 15.15** - Enhanced Windows event logging (SwiftOnSecurity config)
- **OpenSearch** - Log indexing and search

### Operating Systems
- **Ubuntu Server 24.04 LTS** - SIEM server platform
- **Windows 10 Pro** - Monitored endpoint
- **Kali Linux** - Penetration testing and attack simulation

### Virtualization & Networking
- **VMware Workstation** - Virtual infrastructure
- **Windows Internet Connection Sharing (ICS)** - Network connectivity

### Attack Simulation Tools
- **Nmap** - Network reconnaissance
- **Hydra** - Brute force testing
- **PowerShell** - Malicious command execution simulation
- **EICAR** - Malware detection testing

---

## 🚀 Implementation Steps Completed

### Phase 1: Infrastructure Setup
1. ✅ Deployed Ubuntu Server 24.04 LTS (fresh installation)
2. ✅ Configured network using ICS (192.168.137.0/24)
3. ✅ Installed Wazuh 4.14.1 all-in-one using official installation script
4. ✅ Verified all services: wazuh-indexer, wazuh-manager, wazuh-dashboard

### Phase 2: Agent Deployment
1. ✅ Installed Wazuh agent 4.8.0 on Windows 10
2. ✅ Manually registered agent using manage_agents
3. ✅ Configured agent to connect to manager (192.168.137.10:1514)
4. ✅ Verified Active status in agent management

### Phase 3: Enhanced Logging
1. ✅ Installed Sysmon 15.15 with SwiftOnSecurity configuration
2. ✅ Configured Wazuh agent to collect Sysmon logs via eventchannel
3. ✅ Enabled Application, Security, System event log collection
4. ✅ Validated Sysmon Event IDs: 1 (Process), 3 (Network), 11 (File), 22 (DNS)

### Phase 4: Attack Simulations
1. ✅ Encoded PowerShell execution (`-EncodedCommand`)
2. ✅ PowerShell execution policy bypass
3. ✅ EICAR test file creation (malware simulation)
4. ✅ Account discovery using net.exe commands
5. ✅ Privilege enumeration with whoami

### Phase 5: Detection & Analysis
1. ✅ Configured dashboard filters for threat hunting
2. ✅ Analyzed Sysmon events in Discover module
3. ✅ Mapped detections to MITRE ATT&CK framework
4. ✅ Verified high-severity alerts (Level 12)

---

## 🎯 Attack Scenarios & Detection Results

### Attack 1: Encoded PowerShell Execution
**Command Executed:**
```powershell
powershell.exe -EncodedCommand "dwBoAG8AYQBtAGkA"
```

**Detection:**
- ✅ Rule 92057: "Powershell.exe spawned a powershell process which executed a base64 encoded command"
- ✅ Severity Level: **12 (HIGH)**
- ✅ MITRE ATT&CK: **T1059.001** (PowerShell - Command and Scripting Interpreter)
- ✅ Total Events: 8 PowerShell execution alerts

### Attack 2: Execution Policy Bypass
**Command Executed:**
```powershell
powershell.exe -ExecutionPolicy Bypass -Command "Get-Process | Select-Object -First 5"
```

**Detection:**
- ✅ Sysmon Event ID 1 (Process Creation)
- ✅ Command-line arguments logged
- ✅ Parent process tracking (cmd.exe → powershell.exe)

### Attack 3: EICAR Malware Simulation
**Command Executed:**
```powershell
'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' | Out-File C:\Users\Public\malware-test.exe
```

**Detection:**
- ✅ Sysmon Event ID 11 (File Creation)
- ✅ PowerShell spawning executable in suspicious location
- ✅ File path and hash captured

### Attack 4: Account Discovery (Reconnaissance)
**Commands Executed:**
```powershell
net user Administrator
net localgroup Administrators
whoami /priv
```

**Detection:**
- ✅ Multiple "net.exe account discovery command" alerts
- ✅ Discovery activity executed alerts
- ✅ MITRE ATT&CK: **T1087** (Account Discovery)

---

## 📊 MITRE ATT&CK Coverage

| Technique ID | Technique Name | Detection Status |
|--------------|----------------|------------------|
| T1059.001 | PowerShell Execution | ✅ Detected (Level 12) |
| T1087.001 | Account Discovery: Local Account | ✅ Detected |
| T1087.002 | Account Discovery: Domain Account | ✅ Detected |
| T1082 | System Information Discovery | ✅ Detected |
| T1204.002 | User Execution: Malicious File | ✅ Detected |

**Total Sysmon Events Captured:** 34+ in last 24 hours  
**High-Severity Alerts (Level ≥10):** 8 alerts  
**Detection Rate:** 100% for simulated attacks

---

## 🔍 Key Skills Demonstrated

### Technical Skills
- SIEM deployment and configuration (Wazuh)
- Windows event log analysis (Sysmon integration)
- Agent management and authentication
- Network architecture design for security labs
- Log aggregation and indexing (OpenSearch)
- Dashboard creation and threat visualization

### Security Operations
- Threat detection rule analysis
- MITRE ATT&CK framework mapping
- Incident investigation workflows
- Attack simulation and validation
- Log filtering and correlation

### System Administration
- Linux server administration (Ubuntu)
- PowerShell scripting and analysis
- VMware virtualization
- Network troubleshooting (NAT, ICS)
- Service management and monitoring

---

## 📸 Screenshot Checklist

**For LinkedIn Post - Include These:**
1. ✅ **Dashboard Overview** - Showing active agents and alert counts
2. ✅ **High-Severity Alert** - Rule 92057 (Encoded PowerShell, Level 12)
3. ✅ **Sysmon Event Details** - Expanded event showing process tree
4. ✅ **MITRE ATT&CK View** - Techniques detected (T1059.001 highlighted)
5. ⬜ **Architecture Diagram** - Network topology (optional: create in draw.io)
6. ⬜ **Security Events Dashboard** - Alert summary and statistics

**For Project Portfolio:**
- All discovery module searches
- Agent management showing Active status
- Alert timeline showing attack sequence
- Command-line details from Sysmon events
- Rule configuration examples

---

## 🎓 Learning Outcomes

### What I Learned
1. **SIEM Architecture:** Understanding multi-component security monitoring systems
2. **Sysmon Configuration:** Enhanced Windows telemetry beyond default event logs
3. **Threat Detection:** How to map security alerts to MITRE ATT&CK framework
4. **Agent Management:** Manual registration, key exchange, and connectivity troubleshooting
5. **Network Design:** Building isolated security lab environments
6. **Log Analysis:** Filtering, searching, and correlating security events

### Challenges Overcome
1. ❌ → ✅ VMware NAT networking issues → Switched to ICS
2. ❌ → ✅ Agent "Never connected" → Fixed IP configuration in ossec.conf
3. ❌ → ✅ Sysmon logs not appearing → Changed log format from eventlog to eventchannel
4. ❌ → ✅ Certificate errors in initial setup → Fresh installation approach

---

## 🚀 Next Steps & Enhancements

### Phase 6: Advanced Attack Simulations
- [ ] Network port scanning from Kali (nmap -sS)
- [ ] RDP brute force attacks using Hydra
- [ ] Mimikatz credential dumping simulation
- [ ] Lateral movement techniques
- [ ] Persistence mechanism testing

### Phase 7: Custom Detection Rules
- [ ] Create custom rules in `/var/ossec/etc/rules/local_rules.xml`
- [ ] Alert on multiple failed login attempts (frequency-based)
- [ ] Detect suspicious PowerShell command patterns
- [ ] Monitor for specific file modifications
- [ ] Create email/webhook alerting for critical events

### Phase 8: Dashboard & Reporting
- [ ] Build custom dashboards for different attack types
- [ ] Create weekly security summary reports
- [ ] Design incident response playbooks
- [ ] Document investigation workflows
- [ ] Generate executive-level metrics

### Phase 9: Integration & Automation
- [ ] Integrate with threat intelligence feeds
- [ ] Add active response capabilities (IP blocking, process termination)
- [ ] Automate agent deployment scripts
- [ ] Create backup and disaster recovery procedures
- [ ] Implement log retention policies

---

## 📝 Project Files

### Configuration Files
- `/etc/netplan/50-cloud-init.yaml` - Ubuntu network configuration
- `C:\Program Files (x86)\ossec-agent\ossec.conf` - Windows agent config
- `/var/ossec/etc/client.keys` - Agent authentication keys
- `C:\sysmonconfig.xml` - Sysmon configuration (SwiftOnSecurity)

### Documentation
- `GETTING-STARTED.md` - Initial setup guide
- `docs/phase1-summary.md` - Infrastructure deployment
- `docs/phase2-network-setup.md` - Network configuration
- `docs/phase3-log-collection.md` - Agent and Sysmon setup
- `docs/phase4-attack-simulation.md` - Attack scenarios
- `configs/network/ip-addressing-scheme.md` - Network documentation

### Scripts
- `scripts/setup/fix-vmnet1-ip.ps1` - Network troubleshooting
- `scripts/validation/phase2-network-verify.ps1` - Connectivity tests

---

## 🔗 Resources & References

### Official Documentation
- [Wazuh Documentation](https://documentation.wazuh.com/)
- [Sysmon Documentation](https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon)
- [MITRE ATT&CK Framework](https://attack.mitre.org/)

### Configurations Used
- [SwiftOnSecurity Sysmon Config](https://github.com/SwiftOnSecurity/sysmon-config)
- [Wazuh Installation Guide](https://documentation.wazuh.com/current/installation-guide/)

---

## 👤 Project Credits

**Author:** Kartik  
**Project Name:** SOC Home Lab - Wazuh SIEM Implementation  
**Date:** January 2026  
**Environment:** VMware Workstation on Windows 11

---

## 📜 License & Disclaimer

**Educational Purpose:** This project is for cybersecurity education and training only.  
**Ethical Use:** All attack simulations were conducted in an isolated lab environment with authorized systems only.  
**No Malicious Intent:** EICAR test files and attack simulations are industry-standard security testing methods.

---

**Status:** ✅ Project Complete and Ready for Portfolio/LinkedIn Sharing

**Last Updated:** January 12, 2026
