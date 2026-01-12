# PHASE 5: Detection Engineering

## Overview

This phase creates custom Wazuh detection rules to automatically identify the attack patterns simulated in Phase 4. We'll develop rules with proper thresholds, severity levels, and false positive handling.

---

## Objectives

1. ✅ Create brute-force detection rules
2. ✅ Create privilege escalation detection rules
3. ✅ Create malware hash detection rules
4. ✅ Create suspicious PowerShell detection rules
5. ✅ Create abnormal login detection rules
6. ✅ Configure rule thresholds and severity

---

## Prerequisites

- [ ] Phase 4 complete (Attacks executed)
- [ ] Logs flowing to Wazuh Manager
- [ ] Access to Wazuh Manager configuration
- [ ] Understanding of attack patterns from Phase 4

---

## Part 1: Understanding Wazuh Rules

### Rule Structure

Wazuh rules are defined in XML format with the following components:

```xml
<rule id="RULE_ID" level="SEVERITY">
  <if_sid>SID_LIST</if_sid>
  <match>PATTERN</match>
  <description>Description</description>
  <group>attack_type</group>
</rule>
```

**Key Components:**
- **id**: Unique rule identifier (must be > 100000 for custom rules)
- **level**: Severity (0-16, 0=ignore, 15=critical)
- **if_sid**: Parent rule IDs (inheritance)
- **match**: Pattern to match in logs
- **description**: Human-readable description
- **group**: Rule category

### Severity Levels

| Level | Severity | Description |
|-------|----------|-------------|
| 0 | Ignore | Informational only |
| 1-3 | Low | Low risk events |
| 4-6 | Medium | Moderate risk |
| 7-9 | High | High risk events |
| 10-12 | Critical | Critical security events |
| 13-15 | Alert | Immediate action required |

---

## Part 2: Brute-Force Detection Rules

### Rule 2.1: SSH Brute-Force Detection

**Create custom rule file:**

```bash
# On SIEM Server
sudo vim /var/ossec/ruleset/rules/local_rules.xml
```

**Add SSH brute-force rule:**

```xml
<!-- SSH Brute-Force Detection -->
<group name="brute_force,">
  
  <rule id="100001" level="10" frequency="5" timeframe="300">
    <if_sid>5710</if_sid>
    <match>Failed password|authentication failure</match>
    <same_source_ip />
    <description>SSH brute-force attack detected: Multiple failed login attempts from same IP</description>
    <group>authentication_failed,brute_force,</group>
    <mitre>
      <id>T1110</id>
      <id>T1110.001</id>
    </mitre>
  </rule>

  <rule id="100002" level="12" frequency="10" timeframe="300">
    <if_sid>100001</if_sid>
    <same_source_ip />
    <description>SSH brute-force attack (HIGH): 10+ failed attempts from same IP</description>
    <group>authentication_failed,brute_force,</group>
    <mitre>
      <id>T1110.001</id>
    </mitre>
  </rule>

</group>
```

**Rule Logic:**
- Triggers after 5 failed SSH attempts in 5 minutes
- Escalates to HIGH after 10 attempts
- Groups events by source IP

### Rule 2.2: RDP Brute-Force Detection

**Add RDP brute-force rule:**

```xml
<!-- RDP Brute-Force Detection -->
<group name="brute_force,authentication,">

  <rule id="100010" level="10" frequency="5" timeframe="300">
    <if_sid>5715</if_sid>
    <match>Logon failure|Failed logon</match>
    <same_source_ip />
    <description>RDP brute-force attack detected: Multiple failed RDP logons from same IP</description>
    <group>authentication_failed,brute_force,rdp,</group>
    <mitre>
      <id>T1110</id>
      <id>T1110.001</id>
    </mitre>
  </rule>

  <rule id="100011" level="12" frequency="10" timeframe="300">
    <if_sid>100010</if_sid>
    <same_source_ip />
    <description>RDP brute-force attack (HIGH): 10+ failed RDP attempts from same IP</description>
    <group>authentication_failed,brute_force,rdp,</group>
    <mitre>
      <id>T1110.001</id>
    </mitre>
  </rule>

  <!-- Windows Event 4625 - Failed Logon -->
  <rule id="100012" level="8" frequency="5" timeframe="300">
    <if_group>windows,authentication_failed,</if_group>
    <match>Logon Type:\s*(3|10)</match>
    <same_source_ip />
    <description>Multiple RDP/Network logon failures detected</description>
    <group>authentication_failed,brute_force,rdp,</group>
    <mitre>
      <id>T1110.001</id>
    </mitre>
  </rule>

</group>
```

**Rule Logic:**
- Detects Windows Event 4625 (Failed logon)
- Groups by source IP
- Differentiates RDP (Logon Type 10) from network (Logon Type 3)

---

## Part 3: Privilege Escalation Detection

### Rule 3.1: New Admin User Creation

**Add privilege escalation rules:**

```xml
<!-- Privilege Escalation Detection -->
<group name="privilege_escalation,">

  <!-- New Admin User Created -->
  <rule id="100020" level="12">
    <if_group>windows,user_added,</if_group>
    <match>administrators|Administrators|domain admins|Domain Admins</match>
    <description>Privilege escalation detected: User added to administrators group</description>
    <group>privilege_escalation,user_management,</group>
    <mitre>
      <id>T1078</id>
      <id>T1078.002</id>
    </mitre>
  </rule>

  <!-- Windows Event 4728 - Member added to admin group -->
  <rule id="100021" level="12">
    <if_sid>6161</if_sid>
    <match>Administrators|Domain Admins|Enterprise Admins</match>
    <description>Privilege escalation: User added to privileged group</description>
    <group>privilege_escalation,user_management,</group>
    <mitre>
      <id>T1078.002</id>
    </mitre>
  </rule>

  <!-- New User Created -->
  <rule id="100022" level="8">
    <if_group>windows,user_added,</if_group>
    <match>New user|User account created</match>
    <description>New user account created on system</description>
    <group>user_management,</group>
    <mitre>
      <id>T1136</id>
    </mitre>
  </rule>

</group>
```

**Rule Logic:**
- Detects Windows Event 4728 (Member added to admin group)
- Detects Windows Event 4720 (User account created)
- High severity for privilege escalation

---

## Part 4: Malware Hash Detection

### Rule 4.1: Known Malware Hash Detection

**Add malware hash detection:**

```xml
<!-- Malware Hash Detection -->
<group name="malware,">

  <!-- EICAR Test File Hash Detection -->
  <rule id="100030" level="12">
    <if_group>sysmon_event4,</if_group>
    <match>44D88612FEA8A8F36DE82E1278ABB02F|3395856CE81F2B7382DEE72602F798B642141141</match>
    <description>Malware detected: Known malicious file hash (EICAR test file)</description>
    <group>malware,file_hash,</group>
    <mitre>
      <id>T1204</id>
      <id>T1204.002</id>
    </mitre>
  </rule>

  <!-- Generic malware hash detection -->
  <rule id="100031" level="12">
    <if_group>sysmon_event4,</if_group>
    <match>hash="(.*)"</match>
    <list field="hash" lookup="match_key">etc/lists/malware_hashes.txt</list>
    <description>Malware detected: File hash matches known malware database</description>
    <group>malware,file_hash,</group>
    <mitre>
      <id>T1204.002</id>
    </mitre>
  </rule>

</group>
```

**Create malware hash list:**

```bash
# On SIEM Server
sudo vim /var/ossec/etc/lists/malware_hashes.txt
```

**Add EICAR hashes:**

```
44D88612FEA8A8F36DE82E1278ABB02F
3395856CE81F2B7382DEE72602F798B642141141
```

**Rule Logic:**
- Detects specific known malware hashes
- Supports hash list for multiple hashes
- High severity alert

---

## Part 5: Suspicious PowerShell Detection

### Rule 5.1: Base64 Encoded PowerShell

**Add PowerShell detection rules:**

```xml
<!-- Suspicious PowerShell Detection -->
<group name="suspicious_powershell,">

  <!-- Base64 Encoded Command -->
  <rule id="100040" level="10">
    <if_group>windows,powershell,</if_group>
    <match>-EncodedCommand|-Enc|-e\s+[A-Za-z0-9+/=]{100,}</match>
    <description>Suspicious PowerShell: Base64 encoded command detected</description>
    <group>suspicious_powershell,obfuscation,</group>
    <mitre>
      <id>T1059.001</id>
      <id>T1027</id>
    </mitre>
  </rule>

  <!-- IEX (Invoke Expression) Usage -->
  <rule id="100041" level="10">
    <if_group>windows,powershell,</group>
    <match>IEX|Invoke-Expression|iex\s+\$</match>
    <description>Suspicious PowerShell: Invoke-Expression (IEX) usage detected</description>
    <group>suspicious_powershell,code_execution,</group>
    <mitre>
      <id>T1059.001</id>
    </mitre>
  </rule>

  <!-- Download and Execute -->
  <rule id="100042" level="12">
    <if_group>windows,powershell,</if_group>
    <match>DownloadString|DownloadFile.*IEX|Invoke-WebRequest.*IEX</match>
    <description>Suspicious PowerShell: Download and execute pattern detected</description>
    <group>suspicious_powershell,code_execution,malware,</group>
    <mitre>
      <id>T1059.001</id>
      <id>T1105</id>
    </mitre>
  </rule>

  <!-- Obfuscated PowerShell -->
  <rule id="100043" level="10">
    <if_group>windows,powershell,</if_group>
    <match>-\w+\s+\$\w+.*\$\w+.*\|.*ForEach|FromBase64String.*IEX</match>
    <description>Suspicious PowerShell: Obfuscated command detected</description>
    <group>suspicious_powershell,obfuscation,</group>
    <mitre>
      <id>T1059.001</id>
      <id>T1027</id>
    </mitre>
  </rule>

</group>
```

**Rule Logic:**
- Detects base64 encoded commands
- Detects IEX (Invoke-Expression) patterns
- Detects download and execute patterns
- Flags obfuscation techniques

---

## Part 6: Abnormal Login Detection

### Rule 6.1: After-Hours Login

**Add abnormal login detection:**

```xml
<!-- Abnormal Login Detection -->
<group name="abnormal_login,">

  <!-- After-Hours Login (Outside 8 AM - 6 PM) -->
  <rule id="100050" level="8">
    <if_group>windows,authentication_success,</if_group>
    <time>20:00-07:59</time>
    <description>Abnormal login: After-hours authentication detected</description>
    <group>abnormal_login,authentication,</group>
    <mitre>
      <id>T1078</id>
    </mitre>
  </rule>

  <!-- Weekend Login -->
  <rule id="100051" level="7">
    <if_group>windows,authentication_success,</if_group>
    <weekday>saturday,sunday</weekday>
    <description>Abnormal login: Weekend authentication detected</description>
    <group>abnormal_login,authentication,</group>
    <mitre>
      <id>T1078</id>
    </mitre>
  </rule>

  <!-- Multiple Failed Logons Followed by Success -->
  <rule id="100052" level="10" frequency="3" timeframe="600">
    <if_group>windows,authentication_failed,</if_group>
    <same_source_ip />
    <description>Multiple failed logons from IP</description>
    <group>brute_force,authentication_failed,</group>
    <mitre>
      <id>T1110.001</id>
    </mitre>
  </rule>

  <rule id="100053" level="12">
    <if_sid>100052</if_sid>
    <if_group>windows,authentication_success,</if_group>
    <same_source_ip />
    <time>5m</time>
    <description>CRITICAL: Successful login after brute-force attempts from same IP</description>
    <group>authentication_success,brute_force,compromised_account,</group>
    <mitre>
      <id>T1110.001</id>
      <id>T1078</id>
    </mitre>
  </rule>

</group>
```

**Rule Logic:**
- Detects logins outside business hours
- Detects weekend logins
- Correlates failed attempts with successful login

---

## Part 7: Network Scanning Detection

### Rule 7.1: Port Scan Detection

**Add network scanning rules:**

```xml
<!-- Network Scanning Detection -->
<group name="network_scanning,">

  <!-- Multiple Failed Connections to Different Ports -->
  <rule id="100060" level="8" frequency="10" timeframe="300">
    <if_group>sysmon_event3,</if_group>
    <match>Initiated</match>
    <same_source_ip />
    <description>Network scanning detected: Multiple connection attempts to different ports from same IP</description>
    <group>network_scanning,reconnaissance,</group>
    <mitre>
      <id>T1046</id>
    </mitre>
  </rule>

  <!-- Aggressive Port Scan -->
  <rule id="100061" level="10" frequency="20" timeframe="300">
    <if_sid>100060</if_sid>
    <same_source_ip />
    <description>Aggressive port scanning detected: 20+ connection attempts in 5 minutes</description>
    <group>network_scanning,reconnaissance,</group>
    <mitre>
      <id>T1046</id>
    </mitre>
  </rule>

</group>
```

---

## Part 8: Persistence Detection

### Rule 8.1: Startup Persistence

**Add persistence detection:**

```xml
<!-- Persistence Detection -->
<group name="persistence,">

  <!-- Registry Run Key Modification -->
  <rule id="100070" level="8">
    <if_group>sysmon_event13,</if_group>
    <match>CurrentVersion\\Run|CurrentVersion\\RunOnce</match>
    <description>Persistence mechanism detected: Registry Run key modification</description>
    <group>persistence,registry,</group>
    <mitre>
      <id>T1547.001</id>
    </mitre>
  </rule>

  <!-- Scheduled Task Creation -->
  <rule id="100071" level="8">
    <if_group>windows,</if_group>
    <match>scheduled task|Task Scheduler.*created</match>
    <description>Persistence mechanism detected: Scheduled task created</description>
    <group>persistence,scheduled_task,</group>
    <mitre>
      <id>T1053.005</id>
    </mitre>
  </rule>

</group>
```

---

## Part 9: Applying and Testing Rules

### Step 9.1: Save Rules Configuration

**Save all rules to local_rules.xml:**

```bash
# On SIEM Server
sudo vim /var/ossec/ruleset/rules/local_rules.xml
```

**Add all rule groups created above.**

**Verify XML syntax:**

```bash
sudo /var/ossec/bin/wazuh-logtest -t
```

### Step 9.2: Restart Wazuh Manager

```bash
sudo systemctl restart wazuh-manager

# Verify no errors
sudo tail -f /var/ossec/logs/ossec.log
```

### Step 9.3: Test Rules

**Trigger test events from Phase 4 attacks:**

1. Execute brute-force attack → Verify rule 100001/100010 triggers
2. Create admin user → Verify rule 100020 triggers
3. Run EICAR file → Verify rule 100030 triggers
4. Execute encoded PowerShell → Verify rule 100040 triggers

**Verify in Kibana:**

1. Navigate to: **Wazuh** → **Discover**
2. Filter by rule ID: `rule.id: 100001`
3. Verify alerts appear

---

## Part 10: False Positive Handling

### Rule 10.1: Whitelist Legitimate Activity

**Create whitelist rules:**

```xml
<!-- Whitelist Rules -->
<rule id="100100" level="0">
  <if_sid>100040</if_sid>
  <match>user:administrator|user:domain\admin</match>
  <description>Whitelist: Base64 PowerShell from authorized admin user</description>
</rule>

<rule id="100101" level="0">
  <if_sid>100020</if_sid>
  <match>user:Administrator|user:domain\admin</match>
  <description>Whitelist: Admin user creation by authorized admin</description>
</rule>
```

**Rule Logic:**
- Set level to 0 (ignore) for known false positives
- Include specific conditions (user, IP, etc.)

### Rule 10.2: Adjust Thresholds

**Fine-tune frequency thresholds:**

- Increase threshold for noisy rules
- Decrease threshold for critical rules
- Adjust timeframe based on attack patterns

---

## Validation Checklist

- [ ] All custom rules created and saved
- [ ] Rules syntax validated
- [ ] Wazuh Manager restarted
- [ ] Rules tested with Phase 4 attacks
- [ ] Alerts appearing in Kibana
- [ ] False positives identified and whitelisted
- [ ] MITRE ATT&CK mappings added to rules

---

## Rule Summary Table

| Rule ID | Description | Severity | MITRE ATT&CK |
|---------|-------------|----------|--------------|
| 100001 | SSH brute-force (5+ attempts) | 10 | T1110.001 |
| 100010 | RDP brute-force (5+ attempts) | 10 | T1110.001 |
| 100020 | Privilege escalation (admin added) | 12 | T1078.002 |
| 100030 | Malware hash detection (EICAR) | 12 | T1204.002 |
| 100040 | Base64 encoded PowerShell | 10 | T1059.001, T1027 |
| 100050 | After-hours login | 8 | T1078 |
| 100060 | Network port scanning | 8 | T1046 |
| 100070 | Registry persistence | 8 | T1547.001 |

---

## Next Steps

**Phase 5 Status**: ✅ **COMPLETE**

**Ready for**: Phase 6 - Alert Investigation Workflow

---

**Phase 5 Documentation Complete**

