# Security Incident Report Template

**Incident ID:** INC-YYYY-MM-DD-###  
**Date/Time:** YYYY-MM-DD HH:MM UTC  
**Analyst:** Your Name  
**Severity:** Critical / High / Medium / Low  
**Status:** Open / In Progress / Closed  

---

## Executive Summary

[2-3 sentence summary of what happened, impact, and outcome]

Example: "Detected base64-encoded PowerShell execution on endpoint windows10-victim. Investigation confirmed authorized penetration test. No malicious activity detected. System remains secure."

---

## Incident Details

**Alert Information:**
- **Rule ID:** [Wazuh rule number, e.g., 92057]
- **Rule Description:** [What the rule detects]
- **Alert Level:** [1-15 severity scale]
- **MITRE ATT&CK:** [Technique ID and name, e.g., T1059.001 - PowerShell]

**Affected System:**
- **Hostname:** [e.g., windows10-victim]
- **IP Address:** [e.g., 192.168.137.20]
- **Operating System:** [e.g., Windows 10 Pro]
- **User Account:** [Who was logged in]

**Indicator of Compromise (IOC):**
- **Process:** [e.g., powershell.exe]
- **Command Line:** [Full command executed]
- **Parent Process:** [What spawned it]
- **File Hash:** [If file was created/executed]
- **Network Connection:** [IP:Port if applicable]

---

## Timeline of Events

| Time (UTC) | Event Description | Source |
|------------|-------------------|--------|
| HH:MM:SS | User executed command | Windows 10 endpoint |
| HH:MM:SS | Sysmon Event ID X logged | Sysmon |
| HH:MM:SS | Wazuh rule triggered | Wazuh Manager |
| HH:MM:SS | Analyst began investigation | Dashboard |
| HH:MM:SS | Investigation completed | Analyst |

---

## Investigation Steps

### Step 1: Initial Triage
- [ ] Verified alert is genuine (not false positive)
- [ ] Checked agent connectivity status
- [ ] Reviewed alert severity and context
- [ ] Determined urgency level

### Step 2: Evidence Collection
- [ ] Captured screenshot of alert
- [ ] Exported alert JSON from Wazuh
- [ ] Reviewed related Sysmon events
- [ ] Checked process tree (parent-child relationships)
- [ ] Decoded any encoded commands
- [ ] Searched for similar activity on other endpoints

### Step 3: Analysis
**What happened?**
[Describe the sequence of events]

**Is this malicious or benign?**
[Your determination and reasoning]

**What was the user doing?**
[Context about user activity]

### Step 4: Containment (if malicious)
- [ ] Isolated endpoint from network
- [ ] Killed suspicious process
- [ ] Blocked malicious IP/domain
- [ ] Disabled compromised user account

### Step 5: Evidence Preservation
- [ ] Saved all relevant logs
- [ ] Took memory dump (if needed)
- [ ] Captured disk image (if needed)
- [ ] Documented all findings

---

## Root Cause Analysis

**How did this happen?**
[Explain the attack vector or misconfiguration]

**Why was it detected?**
[What detection rule/log source caught it]

**What allowed it to occur?**
[Vulnerability, misconfiguration, user error, etc.]

---

## Evidence & Artifacts

### Screenshots
- `reports/screenshots/YYYY-MM-DD-incident-###-alert.png` - Alert in dashboard
- `reports/screenshots/YYYY-MM-DD-incident-###-sysmon.png` - Sysmon event details
- `reports/screenshots/YYYY-MM-DD-incident-###-timeline.png` - Event timeline

### Log Files
- `reports/incident-reports/YYYY-MM-DD-incident-###-alerts.json` - Raw alert data
- `reports/incident-reports/YYYY-MM-DD-incident-###-sysmon-logs.txt` - Related Sysmon events

### Decoded Artifacts
[If you decoded base64, deobfuscated scripts, etc., include here]

```
Original: dwBoAG8AYQBtAGkA
Decoded: whoami
```

---

## Impact Assessment

**Confidentiality:** None / Low / Medium / High  
[Was data accessed or stolen?]

**Integrity:** None / Low / Medium / High  
[Was data modified or deleted?]

**Availability:** None / Low / Medium / High  
[Was system/service disrupted?]

**Business Impact:**
[How did this affect operations? Downtime? Data loss?]

---

## Response Actions Taken

1. [Action 1]
2. [Action 2]
3. [Action 3]

**Result:** [What was the outcome?]

---

## Lessons Learned

**What went well?**
- Detection worked as expected
- Alert provided sufficient context
- Investigation completed within SLA

**What could be improved?**
- Add additional log sources
- Tune rule to reduce false positives
- Update playbook with new findings

---

## Recommendations

### Immediate Actions
1. [Short-term fix or mitigation]
2. [Patch vulnerability]
3. [Update policy/procedure]

### Long-term Improvements
1. [Detection enhancement]
2. [Security control addition]
3. [Training/awareness initiative]

---

## Escalation & Notification

**Escalated to:** [Manager, IR team, etc. or "None"]  
**External notification:** [Law enforcement, customers, etc. or "None"]  
**Regulatory reporting:** [Required compliance reporting or "None"]

---

## Closure

**Final Status:** Closed - [Reason]
- Confirmed False Positive
- Authorized Activity
- Malware Removed
- Incident Resolved

**Closed By:** [Your name]  
**Closed Date:** YYYY-MM-DD  
**Time to Resolution:** [X hours/days]

---

## Appendix

### Related Incidents
- [Link to similar incidents if any]

### References
- MITRE ATT&CK: [URL to technique]
- Vendor advisory: [If applicable]
- Internal documentation: [Related docs]

---

**Document Version:** 1.0  
**Last Updated:** YYYY-MM-DD  
**Reviewer:** [Optional - peer review]
