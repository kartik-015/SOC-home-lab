# PHASE 7: Incident Response Playbooks

## Overview

This phase creates detailed incident response playbooks for common security incidents. Each playbook follows NIST incident response lifecycle: Preparation, Detection, Containment, Eradication, Recovery, and Lessons Learned.

---

## Objectives

1. ✅ Create brute-force attack IR playbook
2. ✅ Create malware infection IR playbook
3. ✅ Create privilege escalation IR playbook
4. ✅ Define containment strategies
5. ✅ Document recovery procedures

---

## Part 1: Incident Response Lifecycle

### NIST Incident Response Steps

```
PREPARATION
    ↓
DETECTION & ANALYSIS
    ↓
CONTAINMENT
    ↓
ERADICATION
    ↓
RECOVERY
    ↓
POST-INCIDENT ACTIVITY
```

---

## Playbook 1: Brute-Force Attack Response

### Detection Phase

**Alert Indicators:**
- Multiple failed authentication attempts
- Rule ID: 100010, 100011, 100012
- Source IP attempting multiple logons

**Initial Assessment:**
- Verify attack is active or historical
- Identify target account(s)
- Determine attack scope

### Containment Phase

**Immediate Actions:**

1. **Block Source IP**
   ```bash
   # On SIEM Server or firewall
   sudo iptables -A INPUT -s 192.168.56.30 -j DROP
   # Or via Windows Firewall on target
   ```

2. **Disable Affected Account (if compromised)**
   ```cmd
   # On Windows 7
   net user [username] /active:no
   ```

3. **Monitor for Successful Logon**
   - Check for Event 4624 (Successful logon) after failed attempts
   - Review timeline for suspicious activity

**Short-Term Containment:**
- Review all accounts targeted
- Check for successful logons
- Implement temporary IP blocking rules

**Long-Term Containment:**
- Implement rate limiting on authentication
- Enable account lockout policies
- Deploy MFA (if available)

### Eradication Phase

**Remove Threat:**
- Verify source IP is blocked
- Confirm no persistent access established
- Review for any backdoors

**Clean Up:**
- Document all actions taken
- Remove temporary firewall rules (if needed)
- Verify attack has ceased

### Recovery Phase

**Restore Services:**
- Unlock legitimate accounts (if locked)
- Restore normal authentication processes
- Monitor for recurrence

**Verification:**
- Confirm no successful unauthorized access
- Verify system integrity
- Check for any changes made by attacker

### Post-Incident Activity

**Lessons Learned:**
- Review detection rules (adjust thresholds if needed)
- Improve account lockout policies
- Consider implementing MFA

**Detection Improvements:**
- Fine-tune brute-force detection rules
- Add geo-blocking if applicable
- Implement automated IP blocking

---

## Playbook 2: Malware Infection Response

### Detection Phase

**Alert Indicators:**
- Malware hash detection
- Rule ID: 100030, 100031
- Suspicious file execution
- Unusual process behavior

**Initial Assessment:**
- Identify malware type and hash
- Determine infection vector
- Assess potential impact

### Containment Phase

**Immediate Actions:**

1. **Isolate Affected System**
   - Disconnect from network if possible
   - Move to isolated VLAN
   - Prevent lateral movement

2. **Quarantine Malicious File**
   ```cmd
   # On Windows 7
   move "C:\path\to\malware.exe" "C:\Quarantine\"
   ```

3. **Block File Hash**
   - Add hash to detection rules
   - Update malware hash list
   - Prevent re-execution

**Short-Term Containment:**
- Preserve evidence (create snapshot)
- Document file locations
- Identify all affected files

**Long-Term Containment:**
- Implement file integrity monitoring
- Enhance malware detection rules
- Improve endpoint protection

### Eradication Phase

**Remove Malware:**
```cmd
# Identify all related files
# Review process tree
# Check registry for persistence

# Remove malicious files
del /f "C:\path\to\malware.exe"

# Clean registry
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "malware_key" /f

# Remove scheduled tasks
schtasks /delete /tn "malware_task" /f
```

**Verify Removal:**
- Scan system for additional infections
- Check for persistence mechanisms
- Verify no backdoors remain

### Recovery Phase

**Restore System:**
- Restore from clean backup (if available)
- Or perform manual cleanup
- Verify system functionality

**Verification:**
- Run full system scan
- Check network connections
- Review system logs

**Monitoring:**
- Increase monitoring on affected system
- Watch for recurrence
- Monitor for related IOCs

### Post-Incident Activity

**Lessons Learned:**
- Review infection vector (how did it get in?)
- Improve endpoint protection
- Enhance user awareness

**Detection Improvements:**
- Update malware hash lists
- Improve file hash detection rules
- Implement behavioral analysis

---

## Playbook 3: Privilege Escalation Response

### Detection Phase

**Alert Indicators:**
- User added to administrators group
- Rule ID: 100020, 100021
- Windows Event 4728
- Suspicious account creation

**Initial Assessment:**
- Identify compromised account
- Determine who added the user
- Assess privilege level gained

### Containment Phase

**Immediate Actions:**

1. **Remove User from Admin Group**
   ```cmd
   # On Windows 7
   net localgroup administrators [username] /delete
   ```

2. **Disable or Remove User Account**
   ```cmd
   net user [username] /active:no
   # Or delete:
   net user [username] /delete
   ```

3. **Review All Admin Accounts**
   ```cmd
   net localgroup administrators
   ```

**Short-Term Containment:**
- Audit all privilege changes
- Review user account creation
- Check for other compromised accounts

**Long-Term Containment:**
- Implement least privilege principles
- Enable privilege escalation monitoring
- Deploy privileged access management

### Eradication Phase

**Remove Threat:**
- Remove unauthorized admin accounts
- Review all admin group members
- Check for persistent access

**Investigate:**
- How was privilege escalated?
- What was the attacker's goal?
- What actions were taken with elevated privileges?

### Recovery Phase

**Restore Normal Operations:**
- Verify legitimate admin accounts remain
- Restore proper access controls
- Document authorized admins

**Verification:**
- Review all recent admin actions
- Check for unauthorized changes
- Verify system integrity

### Post-Incident Activity

**Lessons Learned:**
- Review privilege escalation vectors
- Improve access control policies
- Enhance monitoring of admin actions

**Detection Improvements:**
- Fine-tune privilege escalation rules
- Implement real-time admin group monitoring
- Add user behavior analytics

---

## Part 4: General IR Procedures

### Evidence Collection

**Preserve Evidence:**
- Create VM snapshots before remediation
- Export relevant logs
- Document timeline
- Save IOCs

**Evidence Storage:**
- Store in secure location
- Maintain chain of custody
- Document all actions

### Communication Plan

**Internal Communication:**
- Notify SOC Manager
- Update incident tracking system
- Document all decisions

**External Communication:**
- Legal/compliance (if required)
- Management (for critical incidents)
- Law enforcement (if required by policy)

### Incident Documentation

**Incident Report Should Include:**
- Incident summary
- Timeline of events
- IOCs extracted
- Actions taken
- Root cause analysis
- Lessons learned
- Recommendations

---

## Part 5: IR Playbook Templates

### Template 5.1: Incident Response Form

```
============================================================================
INCIDENT RESPONSE FORM
============================================================================

INCIDENT ID: INC-YYYY-MMDD-XXX
DATE/TIME: __________________
REPORTED BY: __________________
RESPONDER: __________________
SEVERITY: [ ] Low  [ ] Medium  [ ] High  [ ] Critical

INCIDENT SUMMARY
----------------------------------------------------------------------------
Incident Type: __________________
Affected Systems: __________________
Initial Detection: __________________
Attack Vector: __________________

TIMELINE
----------------------------------------------------------------------------
T-0:00  Detection/Alert
T-0:05  Initial Assessment
T-0:15  Containment Initiated
T-0:30  Eradication Begun
T-1:00  Recovery Phase
T-24:00 Post-Incident Review

CONTAINMENT ACTIONS
----------------------------------------------------------------------------
Immediate:
[ ] System isolated
[ ] Network access blocked
[ ] Accounts disabled
[ ] IPs blocked

Actions Taken:
__________________

ERADICATION ACTIONS
----------------------------------------------------------------------------
Malware Removed: [ ] Yes  [ ] No
Persistence Removed: [ ] Yes  [ ] No
Accounts Removed: [ ] Yes  [ ] No

Actions Taken:
__________________

RECOVERY ACTIONS
----------------------------------------------------------------------------
Systems Restored: [ ] Yes  [ ] No
Services Restored: [ ] Yes  [ ] No
Monitoring Enhanced: [ ] Yes  [ ] No

Actions Taken:
__________________

ROOT CAUSE ANALYSIS
----------------------------------------------------------------------------
How did this happen?
__________________

What was the attacker's goal?
__________________

What was the impact?
__________________

LESSONS LEARNED
----------------------------------------------------------------------------
Detection Improvements:
__________________

Process Improvements:
__________________

Prevention Measures:
__________________

============================================================================
```

---

## Part 6: IR Checklists

### Incident Response Team Checklist

**Detection & Analysis:**
- [ ] Incident detected and logged
- [ ] Initial assessment completed
- [ ] Severity determined
- [ ] Stakeholders notified
- [ ] Incident tracking created

**Containment:**
- [ ] Immediate containment actions taken
- [ ] Short-term containment implemented
- [ ] Long-term containment planned
- [ ] Evidence preserved

**Eradication:**
- [ ] Threat removed
- [ ] Persistence mechanisms removed
- [ ] System cleaned
- [ ] Verification completed

**Recovery:**
- [ ] Systems restored
- [ ] Services verified
- [ ] Monitoring enhanced
- [ ] Normal operations resumed

**Post-Incident:**
- [ ] Incident report completed
- [ ] Lessons learned documented
- [ ] Improvements implemented
- [ ] Case closed

---

## Validation Checklist

- [ ] Brute-force IR playbook created
- [ ] Malware IR playbook created
- [ ] Privilege escalation IR playbook created
- [ ] IR templates created
- [ ] IR checklists documented
- [ ] Procedures tested (simulated)

---

## Next Steps

**Phase 7 Status**: ✅ **COMPLETE**

**Ready for**: Phase 8 - MITRE ATT&CK Mapping

---

**Phase 7 Documentation Complete**

