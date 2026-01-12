# Security Incident Report - Encoded PowerShell Execution

**Incident ID:** INC-2026-01-12-001  
**Date/Time:** 2026-01-12 12:41:00 UTC  
**Analyst:** Kartik  
**Severity:** High (Level 12)  
**Status:** Closed  

---

## Executive Summary

Detected base64-encoded PowerShell execution on endpoint windows10-victim (192.168.137.20) via Wazuh Rule 92057. Investigation revealed authorized penetration testing activity simulating adversary technique T1059.001. Decoded command was harmless ("whoami"). No malicious activity confirmed. Detection validation successful. System secure.

---

## Incident Details

**Alert Information:**
- **Rule ID:** 92057
- **Rule Description:** "Powershell.exe spawned a powershell process which executed a base64 encoded command"
- **Alert Level:** 12 (High Severity)
- **MITRE ATT&CK:** T1059.001 (Command and Scripting Interpreter: PowerShell)

**Affected System:**
- **Hostname:** windows10-victim
- **IP Address:** 192.168.137.20
- **Operating System:** Windows 10 Pro (Build 19045)
- **User Account:** DESKTOP-MGNDRRJ\kartik

**Indicator of Compromise (IOC):**
- **Process:** C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
- **Command Line:** `powershell.exe -EncodedCommand "dwBoAG8AYQBtAGkA"`
- **Parent Process:** C:\Windows\System32\cmd.exe
- **Decoded Command:** `whoami`
- **Process ID:** [From Sysmon logs]

---

## Timeline of Events

| Time (UTC) | Event Description | Source |
|------------|-------------------|--------|
| 12:41:00 | User executed encoded PowerShell command from cmd.exe | Windows 10 endpoint |
| 12:41:00 | Sysmon Event ID 1 captured process creation with full command line | Sysmon |
| 12:41:03 | Wazuh Rule 92057 triggered, alert generated | Wazuh Manager |
| 12:41:15 | Alert appeared in dashboard, analyst notified | Wazuh Dashboard |
| 12:42:00 | Analyst began investigation | Kartik |
| 12:43:00 | Decoded base64 command, confirmed benign test | Kartik |
| 12:45:00 | Investigation completed, incident closed | Kartik |

---

## Investigation Steps

### Step 1: Initial Triage
- ✅ Verified alert authenticity in dashboard
- ✅ Checked agent status: Active, connected
- ✅ Reviewed alert severity: Level 12 (critical attention required)
- ✅ Determined this matched expected test activity

### Step 2: Evidence Collection
- ✅ Captured screenshot of Rule 92057 alert
- ✅ Exported alert JSON from Wazuh
- ✅ Retrieved Sysmon Event ID 1 showing process creation
- ✅ Identified parent process tree: cmd.exe → powershell.exe
- ✅ Decoded base64 string
- ✅ Searched for similar activity: Only instance in timeframe

### Step 3: Analysis
**What happened?**
User executed PowerShell with the `-EncodedCommand` parameter, passing base64-encoded string "dwBoAG8AYQBtAGkA". This spawned a child PowerShell process that executed the decoded command.

**Is this malicious or benign?**
**Benign - Authorized Test Activity**

Reasoning:
1. Decoded command is "whoami" (harmless information gathering)
2. User account matches lab administrator
3. Timing aligns with documented penetration testing schedule
4. No follow-on malicious activity observed
5. No network connections to external IPs
6. No file modifications or persistence mechanisms
7. Part of SOC lab attack simulation validation

**What was the user doing?**
Conducting authorized attack simulation to validate Wazuh detection capability for MITRE ATT&CK technique T1059.001.

### Step 4: Containment
**Not Required** - Confirmed authorized activity

If this had been malicious, containment steps would include:
- Isolate endpoint from network
- Kill suspicious PowerShell process
- Disable user account pending investigation
- Block parent process hash if malware

### Step 5: Evidence Preservation
- ✅ Saved alert JSON to incident folder
- ✅ Captured 3 screenshots (alert, Sysmon details, MITRE mapping)
- ✅ Exported related Sysmon events to text file
- ✅ Documented command-line arguments
- ✅ Created this formal incident report

---

## Root Cause Analysis

**How did this happen?**
Lab administrator intentionally executed encoded PowerShell command as part of attack simulation exercise to test SIEM detection capabilities.

**Why was it detected?**
Wazuh Rule 92057 monitors for suspicious PowerShell process spawning behavior, specifically targeting base64-encoded commands. Sysmon Event ID 1 provided full command-line visibility, enabling the detection rule to identify the encoding.

**What allowed it to occur?**
This is not an exploit or vulnerability - it's expected functionality in a penetration testing lab environment where administrators intentionally simulate attacks.

---

## Evidence & Artifacts

### Screenshots
- `reports/screenshots/2026-01-12-rule-92057-alert.png` - Dashboard showing high-severity alert
- `reports/screenshots/2026-01-12-powershell-sysmon-event.png` - Sysmon Event ID 1 details
- `reports/screenshots/2026-01-12-mitre-attack-t1059.png` - MITRE ATT&CK mapping

### Decoded Artifacts
**Original Base64:**
```
dwBoAG8AYQBtAGkA
```

**Decoded Command:**
```powershell
whoami
```

**Decoding Process:**
```bash
echo "dwBoAG8AYQBtAGkA" | base64 -d
# Output: whoami
```

**Command Output:**
```
DESKTOP-MGNDRRJ\kartik
```

---

## Impact Assessment

**Confidentiality:** None  
No sensitive data accessed beyond user identity (whoami output).

**Integrity:** None  
No system files, registry keys, or data were modified.

**Availability:** None  
No service disruption or system degradation occurred.

**Business Impact:**
Zero business impact. This was a controlled test in an isolated lab environment with no production systems or data involved.

---

## Response Actions Taken

1. ✅ Verified alert authenticity and context
2. ✅ Decoded base64 command to determine intent
3. ✅ Confirmed authorized testing activity
4. ✅ Validated Wazuh detection working as expected
5. ✅ Documented findings for future reference
6. ✅ No containment or remediation required

**Result:** Detection validation successful. Rule 92057 performing as designed. SIEM correctly identified and alerted on MITRE ATT&CK T1059.001 technique.

---

## Lessons Learned

**What went well?**
- ✅ Detection fired immediately (within 3 seconds)
- ✅ Alert provided complete command-line context
- ✅ Severity level (12) appropriately categorized threat
- ✅ Sysmon integration provided rich forensic data
- ✅ Investigation completed within 5 minutes
- ✅ MITRE ATT&CK mapping aided threat understanding

**What could be improved?**
- Consider adding alert suppression for known test accounts
- Create "test mode" tag for lab simulation activities
- Implement alert annotation to mark authorized tests
- Add context enrichment showing user's recent activity
- Develop automated decoding for common encoding types

---

## Recommendations

### Immediate Actions
1. ✅ **Completed:** Document this detection as validation baseline
2. ✅ **Completed:** Add to detection coverage matrix for T1059.001
3. **Next:** Create playbook for handling encoded PowerShell in production

### Long-term Improvements
1. **Detection Enhancement:** Add frequency-based alerting (multiple encoded commands in short time = higher priority)
2. **Contextual Awareness:** Integrate with HR system to auto-tag test accounts
3. **Response Automation:** Develop active response to automatically decode and log base64 commands
4. **Training Material:** Use this incident as teaching example for new analysts

---

## Escalation & Notification

**Escalated to:** None (authorized test activity)  
**External notification:** None required  
**Regulatory reporting:** Not applicable (lab environment)

---

## Closure

**Final Status:** Closed - Authorized Test Activity  
**Classification:** True Positive (malicious technique detected) / Benign Activity (no actual threat)

**Closed By:** Kartik  
**Closed Date:** 2026-01-12  
**Time to Resolution:** 5 minutes (detection to closure)

**Detection Validation:** ✅ **PASSED**
- Rule 92057: Working as designed
- MITRE T1059.001 coverage: Confirmed
- Sysmon integration: Functioning correctly
- Alert severity: Appropriately classified

---

## Appendix

### Related Incidents
- INC-2026-01-12-002: Account Discovery via net.exe
- INC-2026-01-12-003: EICAR malware test file creation

### MITRE ATT&CK References
- **Technique:** T1059.001
- **Tactic:** Execution
- **URL:** https://attack.mitre.org/techniques/T1059/001/
- **Description:** Adversaries abuse PowerShell for execution
- **Detection:** Monitor process execution with command-line arguments
- **Our Coverage:** ✅ Confirmed via Rule 92057

### Commands for Future Reference
```bash
# Check for similar encoded PowerShell activity
sudo grep -i "EncodedCommand" /var/ossec/logs/alerts/alerts.json | jq -r '.rule.description' | sort | uniq -c

# View all PowerShell-related alerts
sudo tail -1000 /var/ossec/logs/alerts/alerts.json | jq 'select(.data.win.eventdata.image | contains("powershell.exe"))'

# Count PowerShell alerts by severity
sudo grep "powershell" /var/ossec/logs/alerts/alerts.json | jq -r '.rule.level' | sort | uniq -c
```

---

**Document Version:** 1.0  
**Last Updated:** 2026-01-12  
**Reviewer:** Self-review completed  
**Approved for Portfolio:** ✅ Yes
