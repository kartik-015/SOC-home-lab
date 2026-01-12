# PHASE 3: Log Collection Setup

## Overview

This phase installs and configures log collection components on all VMs. We'll set up Wazuh Manager on the SIEM Server, Wazuh Agent on Windows 7, Sysmon on Windows 7, and rsyslog forwarding on Kali Linux.

---

## Objectives

1. ✅ Install Wazuh Manager + ELK Stack on SIEM Server
2. ✅ Install and configure Wazuh Agent on Windows 7
3. ✅ Install and configure Sysmon on Windows 7
4. ✅ Configure rsyslog forwarding on Kali Linux
5. ✅ Validate log collection and forwarding

---

## Prerequisites

- [ ] Phase 2 complete (VMs created, network configured)
- [ ] All VMs powered on
- [ ] Internet access temporarily available (enable NAT adapter for downloads)
- [ ] SSH access to SIEM Server
- [ ] Administrator access to Windows 7

---

## Part 1: Wazuh Manager Installation (SIEM Server)

### Step 1.1: Enable Internet Access (Temporary)

**Enable NAT Adapter on SIEM Server:**

1. Power off SIEM Server VM
2. VM Settings → Network Adapter 2 → Enable NAT (VMnet8)
3. Power on VM
4. Configure NAT adapter (if needed)

**Temporary NAT Configuration:**

```bash
# Get NAT adapter name
ip link show

# Configure NAT (DHCP should auto-assign)
# Or manually:
sudo vim /etc/netplan/00-installer-config.yaml
```

**After downloads, disable NAT adapter again for security.**

### Step 1.2: Install Wazuh Manager

**Official Installation (Recommended):**

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install prerequisites
sudo apt install -y curl apt-transport-https lsb-release gnupg2

# Add Wazuh repository
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list

# Update package list
sudo apt update

# Install Wazuh Manager
sudo WAZUH_MANAGER="192.168.56.10" apt install wazuh-manager

# Enable and start Wazuh Manager
sudo systemctl daemon-reload
sudo systemctl enable wazuh-manager
sudo systemctl start wazuh-manager

# Check status
sudo systemctl status wazuh-manager
```

**Verify Installation:**

```bash
# Check Wazuh Manager logs
sudo tail -f /var/ossec/logs/ossec.log

# Verify manager is listening
sudo netstat -tulpn | grep :1514
```

### Step 1.3: Install Elastic Stack (Elasticsearch + Kibana)

**Install Elasticsearch:**

```bash
# Add Elasticsearch repository
curl -s https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list

# Update and install Elasticsearch
sudo apt update
sudo apt install -y elasticsearch=7.17.13

# Configure Elasticsearch
sudo vim /etc/elasticsearch/elasticsearch.yml
```

**Elasticsearch Configuration (`/etc/elasticsearch/elasticsearch.yml`):**

```yaml
# Network settings
network.host: 0.0.0.0
http.port: 9200

# Discovery settings (single node)
discovery.type: single-node

# Memory settings (adjust for your VM)
# Uncomment and set based on available RAM
# Xms and Xmx should be equal and no more than 50% of RAM
# -Xms2g
# -Xmx2g
```

**Start Elasticsearch:**

```bash
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

# Wait for Elasticsearch to start (may take 30-60 seconds)
sleep 30

# Verify Elasticsearch is running
curl -X GET "localhost:9200/?pretty"
```

**Install Kibana:**

```bash
sudo apt install -y kibana=7.17.13

# Configure Kibana
sudo vim /etc/kibana/kibana.yml
```

**Kibana Configuration (`/etc/kibana/kibana.yml`):**

```yaml
# Server settings
server.port: 5601
server.host: "0.0.0.0"

# Elasticsearch connection
elasticsearch.hosts: ["http://localhost:9200"]

# Wazuh plugin
wazuh.version: "4.8.0"
```

**Start Kibana:**

```bash
sudo systemctl daemon-reload
sudo systemctl enable kibana
sudo systemctl start kibana

# Check status
sudo systemctl status kibana

# Wait for Kibana to start (may take 1-2 minutes)
# Access at: http://192.168.56.10:5601
```

### Step 1.4: Install Wazuh API and Connect to Kibana

**Install Wazuh API:**

```bash
sudo apt install -y wazuh-api

# Configure Wazuh API
sudo vim /var/ossec/api/security/security.yaml
```

**Set API password (default user: wazuh):**

```bash
# Generate password hash
cd /var/ossec/api/configuration/security
sudo /var/ossec/api/configuration/security/security_config_reset.py
# Follow prompts to set password (save this password!)
```

**Start Wazuh API:**

```bash
sudo systemctl daemon-reload
sudo systemctl enable wazuh-api
sudo systemctl start wazuh-api

# Verify
sudo systemctl status wazuh-api
```

**Install Wazuh Kibana Plugin:**

```bash
# Install plugin
sudo -u kibana /usr/share/kibana/bin/kibana-plugin install https://packages.wazuh.com/4.x/ui/kibana/wazuh_kibana-4.8.0_7.17.13-1.zip

# Restart Kibana
sudo systemctl restart kibana
```

**Access Kibana:**

1. Open browser on host machine: `http://192.168.56.10:5601`
2. Login with:
   - Username: `wazuh`
   - Password: (the one you set during API setup)

### Step 1.5: Configure Wazuh Manager for Remote Access

**Configure Wazuh Manager:**

```bash
sudo vim /var/ossec/etc/ossec.conf
```

**Update `<remote>` section:**

```xml
<remote>
  <connection>secure</connection>
  <port>1514</port>
  <protocol>tcp</protocol>
  <queue_size>131072</queue_size>
</remote>
```

**Restart Wazuh Manager:**

```bash
sudo systemctl restart wazuh-manager
```

**Configure Firewall:**

```bash
# Allow Wazuh Agent connections
sudo ufw allow 1514/tcp
sudo ufw allow 1515/tcp

# Allow Kibana (optional, for host access)
sudo ufw allow from 192.168.56.1 to any port 5601

# Allow Syslog (for Kali)
sudo ufw allow 514/udp

# Check status
sudo ufw status
```

---

## Part 2: Wazuh Agent Installation (Windows 7)

### Step 2.1: Enable Internet Access (Temporary)

1. Power off Windows 7 VM
2. VM Settings → Network Adapter 2 → Enable NAT
3. Power on VM
4. Configure NAT (should auto-assign via DHCP)

### Step 2.2: Download and Install Wazuh Agent

**Download Wazuh Agent for Windows:**

1. From Windows 7 VM, open browser
2. Download: `https://packages.wazuh.com/4.x/windows/wazuh-agent-4.8.0-1.msi`
3. Or download from SIEM Server and transfer:
   ```bash
   # On SIEM Server
   wget https://packages.wazuh.com/4.x/windows/wazuh-agent-4.8.0-1.msi
   # Transfer via shared folder or SCP
   ```

**Install Wazuh Agent:**

1. Double-click `wazuh-agent-4.8.0-1.msi`
2. Follow installation wizard
3. During installation:
   - **Manager address**: `192.168.56.10`
   - **Port**: `1514`
   - **Agent name**: `windows7-victim` (or leave default)
4. Complete installation

### Step 2.3: Register Agent with Manager

**On SIEM Server, register the agent:**

```bash
# Generate agent key
sudo /var/ossec/bin/manage_agents

# Select option: A) Add an agent
# Enter agent name: windows7-victim
# Enter agent IP: 192.168.56.20
# Enter agent ID (auto-generated or custom): (press Enter for auto)
# Copy the generated key
```

**On Windows 7, import the key:**

1. Open Command Prompt as Administrator
2. Run:
```cmd
cd "C:\Program Files (x86)\ossec-agent"
manage_agents.exe
```

3. Select: `I` - Import key from manager
4. Paste the key from SIEM Server
5. Exit and restart agent:

```cmd
net stop WazuhSvc
net start WazuhSvc
```

### Step 2.4: Configure Windows Event Log Collection

**Edit agent configuration:**

```cmd
# On Windows 7
notepad "C:\Program Files (x86)\ossec-agent\ossec.conf"
```

**Verify Windows Event Log collection is enabled:**

```xml
<ossec_config>
  <localfile>
    <location>Microsoft-Windows-Security-Auditing</location>
    <log_format>eventchannel</log_format>
  </localfile>
  <localfile>
    <location>Microsoft-Windows-PowerShell/Operational</location>
    <log_format>eventchannel</log_format>
  </localfile>
  <localfile>
    <location>Microsoft-Windows-Sysmon/Operational</location>
    <log_format>eventchannel</log_format>
  </localfile>
</ossec_config>
```

**Restart agent:**

```cmd
net stop WazuhSvc
net start WazuhSvc
```

### Step 2.5: Verify Agent Connection

**On SIEM Server, check agent status:**

```bash
# Check agent list
sudo /var/ossec/bin/agent_control -l

# Check agent logs
sudo tail -f /var/ossec/logs/ossec.log | grep windows7

# View agent in Kibana
# Go to: http://192.168.56.10:5601
# Navigate to: Wazuh → Agents
```

---

## Part 3: Sysmon Installation (Windows 7)

### Step 3.1: Download Sysmon

1. Download Sysmon from Microsoft:
   - `https://download.sysinternals.com/files/Sysmon.zip`
2. Extract to: `C:\Sysmon\`

### Step 3.2: Download Sysmon Configuration

**Use SwiftOnSecurity Sysmon Config (Recommended):**

```cmd
# Download configuration
cd C:\Sysmon
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml' -OutFile 'sysmonconfig-export.xml'"
```

### Step 3.3: Install Sysmon

**Install with configuration:**

```cmd
cd C:\Sysmon
sysmon.exe -i sysmonconfig-export.xml -accepteula
```

**Verify Installation:**

```cmd
# Check Sysmon service
sc query Sysmon

# View Sysmon logs in Event Viewer
eventvwr.msc
# Navigate to: Applications and Services Logs → Microsoft → Windows → Sysmon → Operational
```

### Step 3.4: Configure Windows Event Log for Sysmon

**Ensure Sysmon logs are accessible:**

1. Open Event Viewer
2. Navigate to: `Applications and Services Logs → Microsoft → Windows → Sysmon → Operational`
3. Right-click → Properties
4. Ensure logging is enabled
5. Increase log size if needed (512 MB recommended)

**Verify Wazuh Agent can collect Sysmon logs:**

- Wazuh Agent should automatically collect Sysmon events if configured in `ossec.conf` (see Step 2.4)

---

## Part 4: rsyslog Configuration (Kali Linux)

### Step 4.1: Enable Internet Access (Temporary)

1. Power off Kali Linux VM
2. VM Settings → Network Adapter 2 → Enable NAT
3. Power on VM

### Step 4.2: Configure rsyslog Forwarding

**Edit rsyslog configuration:**

```bash
sudo vim /etc/rsyslog.conf
```

**Add at the end of file:**

```
# Forward all logs to Wazuh Manager
*.* @192.168.56.10:514
```

**Or configure specific logs:**

```bash
sudo vim /etc/rsyslog.d/50-wazuh.conf
```

**Content:**

```
# Forward auth logs
auth,authpriv.* @192.168.56.10:514

# Forward syslog
*.info;mail.none;authpriv.none;cron.none @192.168.56.10:514

# Forward SSH logs
daemon.* @192.168.56.10:514
```

**Restart rsyslog:**

```bash
sudo systemctl restart rsyslog
sudo systemctl status rsyslog
```

### Step 4.3: Configure Wazuh Manager to Receive Syslog

**On SIEM Server, configure syslog reception:**

```bash
sudo vim /var/ossec/etc/ossec.conf
```

**Add remote syslog section (if not present):**

```xml
<remote>
  <connection>syslog</connection>
  <port>514</port>
  <protocol>udp</protocol>
  <allowed-ips>192.168.56.30</allowed-ips>
</remote>
```

**Restart Wazuh Manager:**

```bash
sudo systemctl restart wazuh-manager
```

### Step 4.4: Test Syslog Forwarding

**Generate test log on Kali:**

```bash
# Generate a test log entry
logger "SOC Lab Test Log Entry from Kali Linux"

# Check if forwarded to SIEM
# On SIEM Server:
sudo tail -f /var/ossec/logs/ossec.log | grep kali
```

---

## Part 5: Validation and Verification

### Step 5.1: Verify Log Collection

**Check Wazuh Manager Logs:**

```bash
# On SIEM Server
sudo tail -f /var/ossec/logs/ossec.log

# Check for agent connections
sudo /var/ossec/bin/agent_control -l
```

**Expected Output:**
```
windows7-victim (any) 192.168.56.20 active
```

### Step 5.2: Verify in Kibana

**Access Kibana:**

1. Open: `http://192.168.56.10:5601`
2. Login with Wazuh credentials
3. Navigate to: **Wazuh** → **Agents**
4. Verify Windows 7 agent is listed and **Active**

**Check Logs:**

1. Navigate to: **Wazuh** → **Discover**
2. Select index pattern: `wazuh-alerts-*`
3. Verify logs are appearing
4. Filter by agent: `agent.name: windows7-victim`

### Step 5.3: Generate Test Events

**On Windows 7:**

```cmd
# Generate Windows Event Log entry
eventcreate /t INFORMATION /id 999 /l APPLICATION /d "SOC Lab Test Event"

# Generate Sysmon event (by running a program)
notepad.exe
# Close notepad - this generates a Sysmon event
```

**On Kali Linux:**

```bash
# Generate auth log entry
logger -p auth.info "SOC Lab Test Auth Log"

# Generate SSH log entry
sudo systemctl restart ssh
```

**Verify in Kibana:**

1. Refresh Kibana Discover view
2. Verify new events appear
3. Check event details

### Step 5.4: Disable Internet Access (Security)

**After verification, disable NAT adapters:**

1. **SIEM Server**: VM Settings → Network Adapter 2 → Disable
2. **Windows 7**: VM Settings → Network Adapter 2 → Disable
3. **Kali Linux**: VM Settings → Network Adapter 2 → Disable

---

## Troubleshooting

### Issue: Agent Not Connecting

**Solutions:**
```bash
# On SIEM Server, check firewall
sudo ufw status
sudo ufw allow 1514/tcp

# Check agent registration
sudo /var/ossec/bin/agent_control -l

# Check agent logs on Windows
# C:\Program Files (x86)\ossec-agent\ossec.log
```

### Issue: No Logs in Kibana

**Solutions:**
1. Verify Elasticsearch indices: `curl localhost:9200/_cat/indices`
2. Check Kibana index pattern: Settings → Index Patterns
3. Verify time range in Discover view
4. Check Wazuh API connection in Kibana

### Issue: Sysmon Events Not Appearing

**Solutions:**
1. Verify Sysmon is installed: `sc query Sysmon`
2. Check Event Viewer for Sysmon logs
3. Verify Wazuh Agent config includes Sysmon channel
4. Restart Wazuh Agent

---

## Validation Checklist

- [ ] Wazuh Manager installed and running
- [ ] Elasticsearch installed and running
- [ ] Kibana installed and accessible
- [ ] Wazuh Agent installed on Windows 7
- [ ] Agent registered with Manager
- [ ] Windows Event Logs being collected
- [ ] Sysmon installed and configured
- [ ] Sysmon events being collected
- [ ] rsyslog forwarding configured on Kali
- [ ] Syslog reception configured on Wazuh Manager
- [ ] Logs visible in Kibana
- [ ] NAT adapters disabled (security)

---

## Next Steps

**Phase 3 Status**: ✅ **COMPLETE**

**Ready for**: Phase 4 - Attack Simulation

---

## Configuration Files Reference

**Files to save:**
- `/var/ossec/etc/ossec.conf` (Wazuh Manager)
- `C:\Program Files (x86)\ossec-agent\ossec.conf` (Windows Agent)
- `/etc/rsyslog.d/50-wazuh.conf` (Kali rsyslog)
- `C:\Sysmon\sysmonconfig-export.xml` (Sysmon config)

---

**Phase 3 Documentation Complete**

