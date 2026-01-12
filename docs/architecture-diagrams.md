# SOC Architecture Diagrams

This file contains all architecture diagrams in various formats for easy reference and presentation.

---

## Network Topology Diagram (Mermaid)

```mermaid
graph TB
    subgraph "HOST MACHINE"
        HOST[Windows 11 Host<br/>VMware Workstation Pro]
    end
    
    subgraph "VIRTUAL NETWORK - 192.168.56.0/24"
        SIEM[SIEM Server<br/>Ubuntu 20.04<br/>192.168.56.10<br/>Wazuh Manager + ELK]
        WIN[Windows 7 VM<br/>Victim Endpoint<br/>192.168.56.20<br/>Wazuh Agent + Sysmon]
        KALI[Kali Linux VM<br/>Attacker<br/>192.168.56.30<br/>rsyslog]
    end
    
    subgraph "DATA FLOW"
        WIN_LOG[Windows Event Logs<br/>Sysmon Events]
        KALI_LOG[System Logs<br/>Auth Logs]
    end
    
    HOST -->|Manages| SIEM
    HOST -->|Manages| WIN
    HOST -->|Manages| KALI
    
    WIN -->|Logs via Wazuh Agent| SIEM
    WIN_LOG -->|Forwarded| WIN
    
    KALI -->|Logs via rsyslog| SIEM
    KALI_LOG -->|Forwarded| KALI
    
    SIEM -->|Alerts| HOST
    SIEM -->|Dashboards| HOST
    
    style WIN fill:#ff6b6b
    style KALI fill:#ff6b6b
    style SIEM fill:#4ecdc4
    style HOST fill:#ffe66d
```

---

## Data Flow Diagram (Mermaid)

```mermaid
flowchart LR
    subgraph "COLLECTION"
        A[Windows 7<br/>Event Logs] --> B[Wazuh Agent]
        C[Kali Linux<br/>Syslog] --> D[rsyslog]
        E[Sysmon<br/>Events] --> B
    end
    
    subgraph "TRANSMISSION"
        B -->|TLS Encrypted<br/>Port 1514| F[Wazuh Manager]
        D -->|Syslog<br/>Port 514| F
    end
    
    subgraph "PROCESSING"
        F -->|Rule Evaluation| G[Rule Engine]
        G -->|Alerts| H[Alert Queue]
        F -->|Normalized Logs| I[Elasticsearch]
    end
    
    subgraph "VISUALIZATION"
        I -->|Query| J[Kibana]
        J -->|Dashboards| K[SOC Analyst]
        H -->|Alert Details| K
    end
    
    style A fill:#ff6b6b
    style C fill:#ff6b6b
    style F fill:#4ecdc4
    style I fill:#4ecdc4
    style J fill:#4ecdc4
    style K fill:#ffe66d
```

---

## SOC Workflow Diagram (Mermaid)

```mermaid
flowchart TD
    START([Alert Received]) --> TRIAGE{Alert Triage<br/>L1 Analyst}
    TRIAGE -->|False Positive| CLOSE[Close Alert]
    TRIAGE -->|Valid Alert| ASSESS{Severity Assessment}
    
    ASSESS -->|Low/Medium| L1_INVEST[L1 Investigation]
    ASSESS -->|High/Critical| ESCALATE[Escalate to L2]
    
    L1_INVEST --> L1_ACTION[Standard Response<br/>Execute Playbook]
    L1_ACTION --> L1_DOC[Document Actions]
    L1_DOC --> CLOSE
    
    ESCALATE --> L2_INVEST[L2 Deep Investigation]
    L2_INVEST --> TIMELINE[Timeline Analysis]
    TIMELINE --> IOC[IOC Extraction]
    IOC --> MITRE[MITRE ATT&CK Mapping]
    MITRE --> IR[Incident Response]
    
    IR --> CONTAIN[Containment]
    CONTAIN --> ERADICATE[Eradication]
    ERADICATE --> RECOVER[Recovery]
    RECOVER --> REVIEW[Post-Incident Review]
    REVIEW --> REPORT[Incident Report]
    REPORT --> CLOSE
    
    style START fill:#ffe66d
    style ESCALATE fill:#ff6b6b
    style IR fill:#4ecdc4
    style CLOSE fill:#95e1d3
```

---

## Component Interaction Sequence (Mermaid)

```mermaid
sequenceDiagram
    participant W as Windows 7 VM
    participant A as Wazuh Agent
    participant M as Wazuh Manager
    participant E as Elasticsearch
    participant K as Kibana
    participant SOC as SOC Analyst
    
    Note over W: Security Event Occurs
    W->>A: Generate Event Log
    A->>A: Collect & Buffer
    
    Note over A,M: Log Transmission
    A->>M: Send Logs (TLS Encrypted)
    M->>M: Normalize & Decode
    M->>M: Evaluate Rules
    
    alt Rule Matched
        M->>SOC: Generate Alert
    end
    
    M->>E: Index Log Data
    
    Note over SOC,K: Investigation
    SOC->>K: Access Dashboard
    K->>E: Query Logs
    E->>K: Return Results
    K->>SOC: Display Visualizations
    
    SOC->>SOC: Analyze & Respond
```

---

## Network Architecture (Detailed)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          VMWARE NETWORK ARCHITECTURE                      │
└─────────────────────────────────────────────────────────────────────────┘

HOST MACHINE (Windows 11)
│
├── VMware Workstation Pro
│   │
│   ├── VMnet1 (Host-Only Network)
│   │   ├── Subnet: 192.168.56.0/24
│   │   ├── Gateway: 192.168.56.1 (Host)
│   │   ├── DHCP: Disabled (Static IPs)
│   │   └── Internet: NO ACCESS
│   │
│   └── VMnet8 (NAT Network - Optional)
│       ├── Subnet: 192.168.100.0/24
│       ├── Gateway: 192.168.100.2
│       ├── NAT: Enabled
│       └── Internet: OUTBOUND ONLY
│
└── Virtual Machines
    │
    ├── SIEM Server (Ubuntu)
    │   ├── Host-Only IP: 192.168.56.10
    │   ├── NAT IP: 192.168.100.10 (if enabled)
    │   ├── Services:
    │   │   ├── Wazuh Manager: 1514/1515 (TLS)
    │   │   ├── Elasticsearch: 9200
    │   │   ├── Kibana: 5601
    │   │   └── Syslog: 514 (UDP)
    │   └── Firewall: UFW enabled
    │
    ├── Windows 7 VM (Victim)
    │   ├── Host-Only IP: 192.168.56.20
    │   ├── NAT IP: 192.168.100.20 (if enabled)
    │   ├── Services:
    │   │   ├── Wazuh Agent: Outbound to 192.168.56.10:1514
    │   │   ├── RDP: 3389 (for testing)
    │   │   └── Windows Event Log Service
    │   └── Firewall: Windows Firewall
    │
    └── Kali Linux VM (Attacker)
        ├── Host-Only IP: 192.168.56.30
        ├── NAT IP: 192.168.100.30 (if enabled)
        ├── Services:
        │   ├── SSH: 22
        │   ├── rsyslog: Forwarding to 192.168.56.10:514
        │   └── Attack Tools (Metasploit, etc.)
        └── Firewall: UFW enabled
```

---

## Port and Protocol Summary

| Service | Port | Protocol | Direction | Encryption |
|---------|------|----------|-----------|------------|
| Wazuh Agent → Manager | 1514 | TCP | Outbound | TLS |
| Wazuh Agent → Manager (Auth) | 1515 | TCP | Outbound | TLS |
| rsyslog → Wazuh | 514 | UDP/TCP | Outbound | Plain |
| Elasticsearch | 9200 | TCP | Local | None (internal) |
| Kibana | 5601 | TCP | Local | HTTP (no external) |
| RDP (Windows 7) | 3389 | TCP | Inbound | TLS |
| SSH (Kali) | 22 | TCP | Inbound | TLS |

---

## Security Zones

```
┌─────────────────────────────────────────────────────────┐
│              SECURITY ZONE CLASSIFICATION                │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────┐
│  ZONE 1: ISOLATED LAB   │
│  (Host-Only Network)    │
│  Risk: LOW              │
│  Access: Internal Only  │
└─────────────────────────┘
         │
         ├── SIEM Server (192.168.56.10)
         ├── Windows 7 VM (192.168.56.20)
         └── Kali Linux VM (192.168.56.30)

┌─────────────────────────┐
│  ZONE 2: MANAGEMENT     │
│  (Host Machine)         │
│  Risk: LOW              │
│  Access: Local Only     │
└─────────────────────────┘
         │
         └── Windows 11 Host (VMware Workstation)

┌─────────────────────────┐
│  ZONE 3: INTERNET       │
│  (NAT Network - Optional)│
│  Risk: MEDIUM           │
│  Access: Outbound Only  │
└─────────────────────────┘
         │
         └── Only for updates/downloads when needed
```

---

These diagrams can be:
1. **Viewed in GitHub**: Mermaid diagrams render automatically in GitHub markdown
2. **Exported**: Use Mermaid Live Editor (https://mermaid.live) to export as PNG/SVG
3. **Embedded**: Include in presentations and documentation

