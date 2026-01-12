# PHASE 6: Alert Investigation Workflow

## Overview

This phase establishes standardized procedures for SOC analysts to investigate alerts, perform timeline analysis, extract IOCs, and make escalation decisions.

---

## Objectives

1. ✅ Define alert triage workflow
2. ✅ Create investigation templates
3. ✅ Establish timeline analysis procedures
4. ✅ Define IOC extraction process
5. ✅ Create escalation criteria and procedures

---

## Part 1: Alert Triage Workflow

### Step 1.1: Initial Alert Reception

**When alert is received:**

1. **Alert Source**: Kibana dashboard or email notification
2. **Initial Assessment**:
   - Alert ID
   - Timestamp
   - Severity level
   - Source IP/Agent
   - Rule description

### Step 1.2: Triage Decision Tree

```
Alert Received
    │
    ├── False Positive? 
    │   ├── Yes → Document & Close
    │   └── No → Continue
    │
    ├── Severity Level?
    │   ├── Low (1-3) → Standard Investigation (L1)
    │   ├── Medium (4-6) → Standard Investigation (L1)
    │   ├── High (7-9) → Deep Investigation (L2)
    │   └── Critical (10+) → Immediate Escalation (L2)
    │
    └── Known Pattern?
        ├── Yes → Execute Playbook
        └── No → Investigate Further
```

---

## Part 2: Investigation Templates

### Template 2.1: Alert Investigation Form

**Create investigation template:**

```
============================================================================
ALERT INVESTIGATION FORM
============================================================================

Alert ID: __________________
Date/Time: __________________
Investigator: __________________
Severity: [ ] Low  [ ] Medium  [ ] High  [ ] Critical

INITIAL ALERT DETAILS
----------------------------------------------------------------------------
Rule ID: __________________
Rule Description: __________________
Source Agent: __________________
Source IP: __________________
Destination IP: __________________
User Account: __________________
Event ID: __________________

INITIAL ASSESSMENT
----------------------------------------------------------------------------
False Positive?  [ ] Yes  [ ] No
Reason: __________________

Attack Type: __________________
MITRE ATT&CK Technique: __________________

TIMELINE ANALYSIS
----------------------------------------------------------------------------
Initial Event Time: __________________
Last Event Time: __________________
Duration: __________________

Key Events:
1. __________________
2. __________________
3. __________________

INDICATORS OF COMPROMISE (IOCs)
----------------------------------------------------------------------------
IP Addresses:
- __________________
- __________________

File Hashes:
- __________________
- __________________

Domain Names:
- __________________
- __________________

User Accounts:
- __________________
- __________________

Registry Keys:
- __________________
- __________________

ROOT CAUSE ANALYSIS
----------------------------------------------------------------------------
How did this happen?
__________________

What was the attacker's goal?
__________________

What data/systems were affected?
__________________

CONTAINMENT ACTIONS TAKEN
----------------------------------------------------------------------------
[ ] Blocked source IP
[ ] Disabled user account
[ ] Isolated affected system
[ ] Blocked malicious file hash
[ ] Other: __________________

ESCALATION DECISION
----------------------------------------------------------------------------
[ ] Resolved - Close Alert
[ ] Escalate to L2 Analyst
[ ] Escalate to SOC Manager
[ ] Escalate to Incident Response Team

Reason: __________________

LESSONS LEARNED
----------------------------------------------------------------------------
Detection Improvements Needed:
__________________

Process Improvements:
__________________

============================================================================
```

---

## Part 3: Timeline Analysis Procedure

### Step 3.1: Gather Timeline Data

**Using Kibana:**

1. Navigate to **Wazuh** → **Discover**
2. Set time range around alert time
3. Filter by agent: `agent.name: "agent-name"`
4. Sort by timestamp
5. Export results

### Step 3.2: Create Timeline Visualization

**Key Events to Document:**

1. **Initial Compromise**
   - First suspicious activity
   - Entry vector
   - Time of initial access

2. **Reconnaissance**
   - Network scanning
   - Service enumeration
   - User enumeration

3. **Lateral Movement**
   - Internal network connections
   - Credential access
   - Remote service usage

4. **Privilege Escalation**
   - Admin user creation
   - UAC bypass attempts
   - Service manipulation

5. **Persistence**
   - Registry modifications
   - Scheduled tasks
   - Startup programs

6. **Data Exfiltration**
   - File access
   - Network transfers
   - External connections

### Step 3.3: Timeline Template

```
TIMELINE: [Alert Description]

T-0:00  [Initial Event] - Alert triggered
        - Event ID: XXXX
        - Rule ID: XXXXX
        - Description: __________________

T-0:05  [Event] - __________________
        - Details: __________________

T-0:15  [Event] - __________________
        - Details: __________________

T-0:30  [Containment] - Analyst response
        - Action taken: __________________

ATTACK CHAIN:
Initial Access → Execution → Persistence → Privilege Escalation → ...
```

---

## Part 4: IOC Extraction Process

### Step 4.1: Extract IOCs from Alerts

**Common IOC Types:**

1. **IP Addresses**
   - Source IPs
   - Destination IPs
   - C2 servers

2. **File Hashes**
   - MD5
   - SHA1
   - SHA256

3. **Domain Names**
   - C2 domains
   - Malicious URLs

4. **File Paths**
   - Executed files
   - Modified files
   - Created files

5. **Registry Keys**
   - Persistence keys
   - Modified keys

6. **User Accounts**
   - Created accounts
   - Privileged accounts

### Step 4.2: IOC Extraction Template

```
INDICATORS OF COMPROMISE (IOCs)

IP ADDRESSES
----------------------------------------------------------------------------
Source IP: 192.168.56.30
- First Seen: __________________
- Last Seen: __________________
- Purpose: Attack origin
- Action: [ ] Blocked  [ ] Whitelisted

C2 IP: __________________
- First Seen: __________________
- Purpose: Command & Control

FILE HASHES
----------------------------------------------------------------------------
MD5: __________________
SHA256: __________________
File Name: __________________
File Path: __________________
Action: [ ] Quarantined  [ ] Blocked

DOMAIN NAMES
----------------------------------------------------------------------------
Domain: __________________
First Seen: __________________
Purpose: C2 / Exfiltration

USER ACCOUNTS
----------------------------------------------------------------------------
Username: __________________
Created: __________________
Privileges: __________________
Action: [ ] Disabled  [ ] Removed

REGISTRY KEYS
----------------------------------------------------------------------------
Key: __________________
Modified: __________________
Purpose: Persistence

```

### Step 4.3: IOC Validation

**Check IOCs against threat intelligence:**

1. VirusTotal (file hashes, IPs, domains)
2. AbuseIPDB (IP reputation)
3. ThreatCrowd (domain reputation)
4. Internal IOC database

---

## Part 5: Investigation Procedures by Attack Type

### Procedure 5.1: Brute-Force Attack Investigation

**Step 1: Verify Alert**
- Check source IP
- Count failed attempts
- Verify attack is ongoing or completed

**Step 2: Gather Context**
```
Kibana Query:
agent.name: "windows7-victim" AND 
rule.id: 100010 AND 
data.win.eventdata.ipAddress: "192.168.56.30"
```

**Step 3: Check for Compromise**
- Verify if any successful logon occurred
- Check for suspicious activity post-attack
- Review user account changes

**Step 4: Containment**
- Block source IP at firewall
- If account compromised, disable account
- Force password reset

**Step 5: Document**
- Complete investigation form
- Extract IOCs
- Create timeline

### Procedure 5.2: Malware Detection Investigation

**Step 1: Verify Detection**
- Confirm file hash matches malware database
- Check file location and execution

**Step 2: Determine Scope**
```
Kibana Query:
agent.name: "windows7-victim" AND 
rule.id: 100030
```

**Step 3: Check System Impact**
- Review process tree
- Check for network connections
- Review file modifications

**Step 4: Containment**
- Quarantine file
- Block file hash
- Scan system for additional malware

**Step 5: Remediation**
- Remove malicious file
- Clean registry entries
- Remove persistence mechanisms

### Procedure 5.3: Privilege Escalation Investigation

**Step 1: Identify Event**
- Check Windows Event 4728
- Verify user added to admin group

**Step 2: Investigate Context**
- Who added the user?
- When was it added?
- Was it authorized?

**Step 3: Check User Activity**
- Review user login history
- Check for suspicious commands
- Review file access

**Step 4: Containment**
- Remove user from admin group
- Disable or remove user account
- Review all admin group members

---

## Part 6: Escalation Criteria

### Escalation to L2 Analyst

**Triggers:**
- Severity 10+ alerts
- Potential data breach
- Advanced persistent threat indicators
- Multi-stage attack chains
- Unfamiliar attack patterns

### Escalation to SOC Manager

**Triggers:**
- Critical severity alerts (13+)
- Confirmed data breach
- Multiple systems compromised
- Nation-state indicators
- Legal/compliance implications

### Escalation to Incident Response Team

**Triggers:**
- Active incident requiring containment
- Multiple systems affected
- Data exfiltration confirmed
- Advanced malware requiring analysis
- Executive notification required

---

## Part 7: Investigation Checklist

### L1 Analyst Checklist

- [ ] Alert received and logged
- [ ] Initial triage completed
- [ ] False positive determined (if applicable)
- [ ] Alert details documented
- [ ] Timeline created (if required)
- [ ] IOCs extracted
- [ ] Containment actions taken
- [ ] Investigation form completed
- [ ] Escalation decision made
- [ ] Alert status updated

### L2 Analyst Checklist

- [ ] Deep investigation initiated
- [ ] Full timeline analysis completed
- [ ] All IOCs extracted and validated
- [ ] Root cause analysis completed
- [ ] Attack chain mapped to MITRE ATT&CK
- [ ] Containment strategy implemented
- [ ] Incident report created
- [ ] Lessons learned documented
- [ ] Detection rules improved (if needed)

---

## Part 8: Investigation Tools and Queries

### Kibana Query Examples

**Brute-Force Investigation:**
```
agent.name: "windows7-victim" AND 
rule.id: (100010 OR 100011) AND 
data.win.eventdata.ipAddress: "192.168.56.30"
```

**Malware Investigation:**
```
agent.name: "windows7-victim" AND 
rule.id: 100030 AND 
data.win.file.hash.md5: "*"
```

**PowerShell Investigation:**
```
agent.name: "windows7-victim" AND 
rule.id: (100040 OR 100041 OR 100042) AND 
data.win.eventdata.commandLine: "*"
```

**Timeline View:**
```
agent.name: "windows7-victim" AND 
@timestamp: [2024-01-01T10:00:00 TO 2024-01-01T11:00:00]
```

---

## Part 9: Alert Closure Criteria

### Alert Can Be Closed When:

1. **False Positive Confirmed**
   - Legitimate activity verified
   - Rule tuning completed (if needed)

2. **Incident Resolved**
   - Threat contained
   - Systems remediated
   - IOCs documented

3. **Escalated**
   - Handed off to L2/IR team
   - Tracking in incident management system

---

## Validation Checklist

- [ ] Investigation templates created
- [ ] Timeline analysis procedures documented
- [ ] IOC extraction process defined
- [ ] Escalation criteria established
- [ ] Investigation checklists created
- [ ] Sample investigations completed
- [ ] Process documented for team

---

## Next Steps

**Phase 6 Status**: ✅ **COMPLETE**

**Ready for**: Phase 7 - Incident Response Playbooks

---

**Phase 6 Documentation Complete**

