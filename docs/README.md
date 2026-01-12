# 🔒 SOC Home Lab - Wazuh SIEM Implementation

A fully functional Security Operations Center (SOC) home lab featuring Wazuh SIEM for real-time threat detection, log analysis, and incident response.

## 🚀 Quick Links

- **[📖 Full Project Documentation](PROJECT-DOCUMENTATION.md)** - Complete technical details
- **[🔧 Replication Guide](REPLICATION-GUIDE.md)** - Build this lab yourself (step-by-step)
- **[💼 LinkedIn Post Templates](LINKEDIN-POST-GUIDE.md)** - Share your project professionally

## 🎯 What This Lab Does

✅ **Real-time threat detection** with Wazuh SIEM 4.14.1  
✅ **Enhanced Windows telemetry** using Sysmon 15.15  
✅ **Attack simulation** and validation (100% detection rate)  
✅ **MITRE ATT&CK mapping** (T1059.001, T1087, T1082)  
✅ **Multi-system monitoring** (Ubuntu + Windows + Kali)

## 🛠️ Tech Stack

`Wazuh SIEM` • `Sysmon` • `Ubuntu Server 24.04` • `VMware` • `OpenSearch` • `Kali Linux` • `PowerShell`

## 📊 Results

- **Detection Rate:** 100% on simulated attacks
- **Events Logged:** 34+ Sysmon events in 24 hours
- **High-Severity Alerts:** 8 critical alerts (Level ≥10)
- **Response Time:** Real-time (<2 minutes)

## 🎓 Skills Demonstrated

SIEM Configuration • Log Analysis • Threat Detection • Incident Response • MITRE ATT&CK • Agent Management • Sysmon Integration • Network Architecture


## 🏗️ Architecture

Windows 11 Host (192.168.137.1)
├── Ubuntu Server 24.04 (192.168.137.10) - Wazuh SIEM
│ ├── Wazuh Manager
│ ├── OpenSearch Indexer
│ └── Web Dashboard
├── Windows 10 Pro (192.168.137.20) - Monitored Endpoint
│ ├── Wazuh Agent 4.8.0
│ └── Sysmon 15.15
└── Kali Linux (192.168.137.30) - Attack Simulation

1. **[Phase 1: SOC Architecture Design](phase1-architecture.md)**
   - Architecture diagrams (ASCII + Mermaid)
   - Data flow explanation
   - SOC roles and responsibilities

2. **[Phase 2: VM & Network Setup](phase2-network-setup.md)** (Coming Soon)
   - VMware network configuration
   - IP addressing scheme
   - Connectivity verification

3. **[Phase 3: Log Collection](phase3-log-collection.md)** (Coming Soon)
   - Wazuh agent installation
   - Sysmon configuration
   - rsyslog setup

4. **[Phase 4: Attack Simulation](phase4-attack-simulation.md)** (Coming Soon)
   - Controlled attack scenarios
   - Attack commands and procedures
   - Safety guidelines

5. **[Phase 5: Detection Engineering](phase5-detection-rules.md)** (Coming Soon)
   - Custom detection rules
   - Rule logic and thresholds
   - False positive handling

6. **[Phase 6: Alert Investigation Workflow](phase6-investigation-workflow.md)** (Coming Soon)
   - Triage procedures
   - Investigation templates
   - Analyst checklists

7. **[Phase 7: Incident Response](phase7-incident-response.md)** (Coming Soon)
   - IR playbooks
   - Containment procedures
   - Recovery steps

8. **[Phase 8: MITRE ATT&CK Mapping](phase8-mitre-mapping.md)** (Coming Soon)
   - Attack technique mapping
   - Tactic/technique tables
   - Sub-technique details

9. **[Phase 9: Dashboards & Visualization](phase9-dashboards.md)** (Coming Soon)
   - Dashboard creation
   - Visualization guidelines
   - Monitoring views

10. **[Phase 10: Documentation & Portfolio](phase10-documentation.md)** (Coming Soon)
    - README generation
    - Incident report templates
    - Resume materials

---


## 🚀 Want to Build This Yourself?

Check out the **[Replication Guide](REPLICATION-GUIDE.md)** for complete step-by-step instructions!

**Prerequisites:** 16GB RAM, 100GB disk, VMware Workstation

**Time Required:** 3-5 hours initial setup


⭐ **Star this repo if you found it helpful!**


## Quick Reference

- **Main README**: [../README.md](../README.md)
- **Configs**: [../configs/](../configs/)
- **Scripts**: [../scripts/](../scripts/)
- **Playbooks**: [../playbooks/](../playbooks/)


