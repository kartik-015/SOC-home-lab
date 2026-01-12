# SOC Home Lab - Quick Reference

## Phase 1: Architecture Quick Reference

### 🏗️ Architecture Components

```
HOST (Windows 11)
  └── VMware Workstation
      ├── SIEM Server (Ubuntu) - 192.168.56.10
      ├── Windows 7 VM - 192.168.56.20
      └── Kali Linux VM - 192.168.56.30
```

### 📊 Data Flow (7 Steps)

1. **Log Generation** → Windows Event Logs, Sysmon, Syslog
2. **Collection** → Wazuh Agent, rsyslog
3. **Transmission** → TLS (Port 1514), Syslog (Port 514)
4. **Processing** → Wazuh Manager (Rule Engine)
5. **Storage** → Elasticsearch (Indexed logs)
6. **Visualization** → Kibana (Dashboards)
7. **Action** → SOC Analyst (Investigation & Response)

### 👥 SOC Roles

| Role | Responsibilities | Escalation |
|------|-----------------|------------|
| **L1 Analyst** | Alert triage, initial analysis, playbook execution | High/Critical alerts |
| **L2 Analyst** | Deep investigation, IOC extraction, IR coordination | APT, major breaches |
| **SOC Manager** | Team management, metrics, executive reporting | Legal/compliance |

### 🌐 Network Design

- **Host-Only Network**: `192.168.56.0/24` (Primary)
- **NAT Network**: `192.168.100.0/24` (Optional, updates only)
- **Security**: Isolated, no internet exposure

### 🔧 Key Tools

| Tool | Purpose | Port |
|------|---------|------|
| Wazuh Manager | SIEM engine, rule processing | 1514/1515 |
| Elasticsearch | Log storage and indexing | 9200 |
| Kibana | Visualization and dashboards | 5601 |
| Wazuh Agent | Endpoint log collection | Outbound |
| Sysmon | Windows process/network monitoring | Event Log |
| rsyslog | Linux log forwarding | 514 |

### 🔒 Security Rules

- ✅ Host-only network isolation
- ✅ TLS encryption for agent communication
- ✅ EICAR testing only (no real malware)
- ✅ Least privilege for all services
- ✅ No port forwarding to internet

### 📁 Project Structure

```
SOC home lab/
├── README.md
├── docs/
│   ├── phase1-architecture.md
│   ├── phase1-summary.md
│   ├── architecture-diagrams.md
│   └── [Phase 2-10 docs...]
├── configs/          # Configuration files
├── scripts/          # Automation scripts
├── playbooks/        # IR playbooks
└── reports/          # Incident reports
```

### ✅ Phase 1 Completion

- [x] Architecture diagrams (ASCII + Mermaid)
- [x] Data flow documentation
- [x] SOC roles defined
- [x] Network architecture
- [x] Component rationale
- [x] Security practices

---

**Next**: Phase 2 - VM & Network Setup

