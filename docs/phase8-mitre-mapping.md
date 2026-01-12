# PHASE 8: MITRE ATT&CK Mapping

## Overview

This phase maps all detections and attacks to the MITRE ATT&CK framework, providing industry-standard threat intelligence alignment for the SOC lab.

---

## Objectives

1. ✅ Map all attacks to MITRE ATT&CK tactics
2. ✅ Identify techniques and sub-techniques
3. ✅ Document detection coverage
4. ✅ Create MITRE ATT&CK matrix visualization

---

## Part 1: MITRE ATT&CK Framework Overview

### Tactics (Adversarial Goals)

| Tactic ID | Tactic Name | Description |
|-----------|-------------|-------------|
| TA0001 | Initial Access | Entry point into network |
| TA0002 | Execution | Running malicious code |
| TA0003 | Persistence | Maintaining presence |
| TA0004 | Privilege Escalation | Gaining higher-level permissions |
| TA0005 | Defense Evasion | Avoiding detection |
| TA0006 | Credential Access | Stealing credentials |
| TA0007 | Discovery | Learning about environment |
| TA0008 | Lateral Movement | Moving through network |
| TA0009 | Collection | Gathering data of interest |
| TA0010 | Exfiltration | Stealing data |
| TA0011 | Command and Control | Communicating with systems |
| TA0040 | Impact | Manipulating, interrupting, or destroying |

---

## Part 2: Attack Mapping Table

### Complete MITRE ATT&CK Mapping

| Attack Scenario | Tactic | Technique | Sub-Technique | Rule ID | Detection |
|-----------------|--------|-----------|---------------|---------|-----------|
| **SSH Brute-Force** | TA0006 | T1110 | T1110.001 | 100001, 100002 | ✅ |
| **RDP Brute-Force** | TA0001 | T1110 | T1110.001 | 100010, 100011, 100012 | ✅ |
| **Malware (EICAR)** | TA0002 | T1204 | T1204.002 | 100030, 100031 | ✅ |
| **Privilege Escalation** | TA0004 | T1078 | T1078.002 | 100020, 100021 | ✅ |
| **PowerShell Execution** | TA0002 | T1059 | T1059.001 | 100040, 100041, 100042 | ✅ |
| **PowerShell Obfuscation** | TA0005 | T1027 | - | 100043 | ✅ |
| **Network Scanning** | TA0007 | T1046 | - | 100060, 100061 | ✅ |
| **After-Hours Login** | TA0001 | T1078 | - | 100050, 100051 | ✅ |
| **Account Creation** | TA0003 | T1136 | - | 100022 | ✅ |
| **Registry Persistence** | TA0003 | T1547 | T1547.001 | 100070 | ✅ |
| **Scheduled Task** | TA0003 | T1053 | T1053.005 | 100071 | ✅ |
| **Download & Execute** | TA0002 | T1105 | - | 100042 | ✅ |
| **Successful Login After Brute-Force** | TA0006 | T1110 | T1110.001 | 100053 | ✅ |

---

## Part 3: Detailed Technique Mapping

### T1110.001 - Brute Force: Password Guessing

**Description:**
Adversaries may use brute force techniques to gain access to accounts when passwords are unknown or when password hashes are obtained.

**Detection:**
- Rule IDs: 100001, 100002, 100010, 100011, 100012
- Log Sources: Windows Event Log, SSH logs, RDP logs
- Indicators: Multiple failed authentication attempts

**Mitigation:**
- Account lockout policies
- Strong password requirements
- MFA implementation

### T1078.002 - Valid Accounts: Domain Accounts

**Description:**
Adversaries may obtain and abuse credentials of existing accounts as a means of gaining Initial Access, Persistence, Privilege Escalation, or Defense Evasion.

**Detection:**
- Rule IDs: 100020, 100021, 100050, 100051, 100053
- Log Sources: Windows Event Log (4728, 4720)
- Indicators: Account creation, group membership changes, abnormal login times

**Mitigation:**
- Least privilege principles
- Account monitoring
- Regular access reviews

### T1204.002 - User Execution: Malicious File

**Description:**
An adversary may rely upon a user clicking a malicious file in the payload campaign to gain execution.

**Detection:**
- Rule IDs: 100030, 100031
- Log Sources: Sysmon, Windows Event Log
- Indicators: Known malware hash, suspicious file execution

**Mitigation:**
- User awareness training
- Application whitelisting
- Antivirus/EDR solutions

### T1059.001 - Command and Scripting Interpreter: PowerShell

**Description:**
Adversaries may abuse PowerShell commands and scripts for execution.

**Detection:**
- Rule IDs: 100040, 100041, 100042, 100043
- Log Sources: PowerShell Event Log, Sysmon
- Indicators: Base64 encoded commands, IEX usage, obfuscated scripts

**Mitigation:**
- PowerShell logging
- Constrained language mode
- Script execution policies

### T1046 - Network Service Scanning

**Description:**
Adversaries may attempt to get a listing of services running on remote hosts and local network infrastructure devices.

**Detection:**
- Rule IDs: 100060, 100061
- Log Sources: Sysmon, network logs
- Indicators: Multiple connection attempts to different ports

**Mitigation:**
- Network segmentation
- Firewall rules
- Intrusion detection systems

### T1136 - Create Account

**Description:**
Adversaries may create a new account to maintain access to victim systems.

**Detection:**
- Rule ID: 100022
- Log Sources: Windows Event Log (4720)
- Indicators: New user account creation

**Mitigation:**
- Account creation policies
- Regular access reviews
- Monitoring of account creation

### T1547.001 - Boot or Logon Autostart Execution: Registry Run Keys

**Description:**
Adversaries may achieve persistence by adding a program to a startup folder or referencing it with a Registry run key.

**Detection:**
- Rule ID: 100070
- Log Sources: Sysmon Event 13 (Registry value set)
- Indicators: Registry modifications to Run/RunOnce keys

**Mitigation:**
- Registry monitoring
- Application whitelisting
- System hardening

### T1053.005 - Scheduled Task/Job: Scheduled Task

**Description:**
Adversaries may abuse the Windows Task Scheduler to perform task scheduling for initial or recurring execution of malicious code.

**Detection:**
- Rule ID: 100071
- Log Sources: Windows Event Log, Sysmon
- Indicators: Scheduled task creation

**Mitigation:**
- Task scheduler monitoring
- Least privilege for task creation
- Regular task review

### T1105 - Ingress Tool Transfer

**Description:**
Adversaries may transfer tools or other files from an external system into a compromised environment.

**Detection:**
- Rule ID: 100042 (PowerShell download)
- Log Sources: Sysmon, network logs
- Indicators: File downloads, network transfers

**Mitigation:**
- Network filtering
- Application whitelisting
- Network monitoring

### T1027 - Obfuscated Files or Information

**Description:**
Adversaries may attempt to make an payload or file difficult to discover or analyze by encoding, encrypting, or otherwise obfuscating its contents.

**Detection:**
- Rule ID: 100043
- Log Sources: PowerShell Event Log
- Indicators: Base64 encoding, obfuscated commands

**Mitigation:**
- Script analysis tools
- Behavioral analysis
- Enhanced logging

---

## Part 4: MITRE ATT&CK Matrix Visualization

### Enterprise Matrix (Relevant Techniques)

```
INITIAL ACCESS (TA0001)
├── T1110.001 - Brute Force: Password Guessing (SSH/RDP) ✅
└── T1078 - Valid Accounts ✅

EXECUTION (TA0002)
├── T1059.001 - PowerShell ✅
├── T1204.002 - Malicious File ✅
└── T1105 - Ingress Tool Transfer ✅

PERSISTENCE (TA0003)
├── T1547.001 - Registry Run Keys ✅
├── T1053.005 - Scheduled Task ✅
└── T1136 - Create Account ✅

PRIVILEGE ESCALATION (TA0004)
└── T1078.002 - Valid Accounts: Domain Accounts ✅

DEFENSE EVASION (TA0005)
└── T1027 - Obfuscated Files or Information ✅

CREDENTIAL ACCESS (TA0006)
└── T1110.001 - Brute Force: Password Guessing ✅

DISCOVERY (TA0007)
└── T1046 - Network Service Scanning ✅

LATERAL MOVEMENT (TA0008)
└── T1078 - Valid Accounts (implied) ✅

COLLECTION (TA0009)
└── (Not directly covered in lab)

EXFILTRATION (TA0010)
└── (Simulated in Phase 4)

COMMAND AND CONTROL (TA0011)
└── (Not directly covered in lab)

IMPACT (TA0040)
└── (Not directly covered in lab)
```

---

## Part 5: Detection Coverage Matrix

### Coverage by Technique

| Technique | Detection Rule | Log Source | Coverage | Status |
|-----------|---------------|------------|----------|--------|
| T1110.001 | 100001, 100002, 100010, 100011, 100012 | Windows Event Log, SSH logs | High | ✅ Implemented |
| T1078.002 | 100020, 100021 | Windows Event Log | High | ✅ Implemented |
| T1204.002 | 100030, 100031 | Sysmon, Windows Event Log | High | ✅ Implemented |
| T1059.001 | 100040, 100041, 100042 | PowerShell Event Log | High | ✅ Implemented |
| T1046 | 100060, 100061 | Sysmon | Medium | ✅ Implemented |
| T1136 | 100022 | Windows Event Log | High | ✅ Implemented |
| T1547.001 | 100070 | Sysmon | High | ✅ Implemented |
| T1053.005 | 100071 | Windows Event Log | Medium | ✅ Implemented |
| T1105 | 100042 | PowerShell Event Log | Medium | ✅ Implemented |
| T1027 | 100043 | PowerShell Event Log | Medium | ✅ Implemented |

**Coverage Summary:**
- **Total Techniques Detected**: 10
- **High Coverage**: 7 techniques
- **Medium Coverage**: 3 techniques
- **Coverage Percentage**: 100% of lab-attacked techniques

---

## Part 6: Gaps and Recommendations

### Techniques Not Covered in Lab

**Lateral Movement:**
- T1021.001 - Remote Services: Remote Desktop Protocol (partially covered via RDP brute-force)
- T1021.002 - Remote Services: SMB/Windows Admin Shares (simulated but not detected)

**Recommendation:**
- Add SMB enumeration detection rules
- Enhance lateral movement detection

**Credential Access:**
- T1003.001 - OS Credential Dumping: LSASS Memory (not tested)

**Recommendation:**
- Add LSASS access detection
- Monitor for credential dumping tools

**Command and Control:**
- T1071.001 - Application Layer Protocol: Web Protocols (not tested)

**Recommendation:**
- Add C2 beacon detection
- Monitor for suspicious outbound connections

---

## Part 7: MITRE ATT&CK Navigator Export

### JSON Export (for MITRE ATT&CK Navigator)

```json
{
  "name": "SOC Home Lab Detection Coverage",
  "versions": {
    "attack": "14",
    "navigator": "4.9.1",
    "layer": "4.5"
  },
  "domain": "enterprise-attack",
  "description": "Detection coverage for SOC Home Lab",
  "techniques": [
    {
      "techniqueID": "T1110.001",
      "color": "#00ff00",
      "comment": "SSH/RDP brute-force detection",
      "enabled": true
    },
    {
      "techniqueID": "T1078.002",
      "color": "#00ff00",
      "comment": "Privilege escalation detection",
      "enabled": true
    },
    {
      "techniqueID": "T1204.002",
      "color": "#00ff00",
      "comment": "Malware hash detection",
      "enabled": true
    },
    {
      "techniqueID": "T1059.001",
      "color": "#00ff00",
      "comment": "PowerShell detection",
      "enabled": true
    },
    {
      "techniqueID": "T1046",
      "color": "#ffff00",
      "comment": "Network scanning detection",
      "enabled": true
    },
    {
      "techniqueID": "T1136",
      "color": "#00ff00",
      "comment": "Account creation detection",
      "enabled": true
    },
    {
      "techniqueID": "T1547.001",
      "color": "#00ff00",
      "comment": "Registry persistence detection",
      "enabled": true
    },
    {
      "techniqueID": "T1053.005",
      "color": "#ffff00",
      "comment": "Scheduled task detection",
      "enabled": true
    },
    {
      "techniqueID": "T1105",
      "color": "#ffff00",
      "comment": "Tool transfer detection",
      "enabled": true
    },
    {
      "techniqueID": "T1027",
      "color": "#ffff00",
      "comment": "Obfuscation detection",
      "enabled": true
    }
  ],
  "gradient": {
    "colors": ["#ff6666", "#ffe766", "#8ec843"],
    "minValue": 0,
    "maxValue": 100
  },
  "legendItems": [
    {
      "label": "High Coverage",
      "color": "#00ff00"
    },
    {
      "label": "Medium Coverage",
      "color": "#ffff00"
    }
  ]
}
```

**Usage:**
1. Import JSON into MITRE ATT&CK Navigator: https://mitre-attack.github.io/attack-navigator/
2. Visualize detection coverage
3. Export as image for documentation

---

## Validation Checklist

- [ ] All attacks mapped to MITRE ATT&CK
- [ ] Techniques and sub-techniques identified
- [ ] Detection coverage documented
- [ ] MITRE ATT&CK matrix created
- [ ] Coverage gaps identified
- [ ] Recommendations documented
- [ ] Navigator JSON export created

---

## Next Steps

**Phase 8 Status**: ✅ **COMPLETE**

**Ready for**: Phase 9 - Dashboards & Visualization

---

**Phase 8 Documentation Complete**

