# Network IP Addressing Scheme

## Host-Only Network: 192.168.56.0/24

| Component | IP Address | Subnet Mask | Gateway | DNS | Notes |
|-----------|-----------|-------------|---------|-----|-------|
| **Host Machine** | 192.168.56.1 | 255.255.255.0 | N/A | N/A | VMware VMnet1 adapter |
| **SIEM Server** | 192.168.56.10 | 255.255.255.0 | 192.168.56.1 | 8.8.8.8, 8.8.4.4 | Ubuntu Server |
| **Windows 7 VM** | 192.168.56.20 | 255.255.255.0 | 192.168.56.1 | 8.8.8.8, 8.8.4.4 | Victim endpoint |
| **Kali Linux VM** | 192.168.56.30 | 255.255.255.0 | 192.168.56.1 | 8.8.8.8, 8.8.4.4 | Attacker endpoint |

**Reserved IPs:** 192.168.56.2 - 192.168.56.9 (for future expansion)

---

## NAT Network: 192.168.100.0/24 (Optional)

| Component | IP Address | Subnet Mask | Gateway | Notes |
|-----------|-----------|-------------|---------|-------|
| **NAT Gateway** | 192.168.100.2 | 255.255.255.0 | N/A | VMware NAT service |
| **SIEM Server** | 192.168.100.10 | 255.255.255.0 | 192.168.100.2 | **DISABLED by default** |
| **Windows 7 VM** | 192.168.100.20 | 255.255.255.0 | 192.168.100.2 | **DISABLED by default** |
| **Kali Linux VM** | 192.168.100.30 | 255.255.255.0 | 192.168.100.2 | **DISABLED by default** |

**Usage:** Only enable NAT adapter when internet access is required for updates/downloads.

---

## Port Assignments

| Service | Port | Protocol | Component | Direction |
|---------|------|----------|-----------|-----------|
| Wazuh Agent | 1514/1515 | TCP | Windows 7 → SIEM | Outbound |
| Elasticsearch | 9200 | TCP | SIEM Server | Local |
| Kibana | 5601 | TCP | SIEM Server | Local (host access) |
| Syslog | 514 | UDP/TCP | Kali → SIEM | Outbound |
| SSH | 22 | TCP | All Linux VMs | Inbound |
| RDP | 3389 | TCP | Windows 7 | Inbound (optional) |

---

## Network Diagram

```
192.168.56.0/24 Network (Host-Only)

192.168.56.1 (Host)
    │
    ├── 192.168.56.10 (SIEM Server - Ubuntu)
    │   └── Wazuh Manager, Elasticsearch, Kibana
    │
    ├── 192.168.56.20 (Windows 7 VM)
    │   └── Wazuh Agent, Sysmon
    │
    └── 192.168.56.30 (Kali Linux VM)
        └── rsyslog, Attack Tools
```

---

## Quick Reference Commands

### Verify IP Configuration

**Windows (Host):**
```cmd
ipconfig
```

**Windows 7 VM:**
```cmd
ipconfig /all
```

**Linux (SIEM/Kali):**
```bash
ip addr show
# Or
ifconfig
```

### Test Connectivity

**From Host:**
```cmd
ping 192.168.56.10
ping 192.168.56.20
ping 192.168.56.30
```

**From SIEM Server:**
```bash
ping -c 4 192.168.56.20
ping -c 4 192.168.56.30
```

**From Windows 7:**
```cmd
ping 192.168.56.10
ping 192.168.56.30
```

**From Kali:**
```bash
ping -c 4 192.168.56.10
ping -c 4 192.168.56.20
```

---

## Configuration Files Location

- **SIEM Server**: `/etc/netplan/00-installer-config.yaml`
- **Kali Linux**: `/etc/network/interfaces` or `/etc/netplan/00-installer-config.yaml`
- **Windows 7**: Network Adapter Properties (GUI)
- **Host**: VMware Virtual Network Editor

---

**Last Updated**: Phase 2 - Network Setup

