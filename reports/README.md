# Reports Folder - Organization Guide

## 📁 Folder Structure

```
reports/
├── incident-reports/          # Individual security incident investigations
├── screenshots/              # Evidence and dashboard captures
├── weekly-summaries/         # Periodic security summaries
├── detection-validation/     # Detection testing results
├── REPORT-TEMPLATE-INCIDENT.md    # Copy this for new incidents
└── README.md                 # This file
```

---

## 🎯 Purpose

This folder contains all investigation outputs, findings, and evidence from your SOC lab operations. These reports serve multiple purposes:

1. **Portfolio Evidence:** Show employers actual security analysis work
2. **Learning Documentation:** Track what you learned from each investigation
3. **Detection Validation:** Prove your SIEM detections work
4. **Professional Practice:** Develop real SOC documentation skills

---

## 📝 Report Types & When to Use

### 1. Incident Reports (`incident-reports/`)

**When to create:**
- Every time you investigate a security alert
- When you simulate an attack and analyze detection
- After discovering suspicious activity

**Naming Convention:**
```
YYYY-MM-DD-INC-###-short-description.md

Examples:
2026-01-12-INC-001-encoded-powershell.md
2026-01-12-INC-002-account-discovery.md
2026-01-13-INC-003-brute-force-attempt.md
```

**What to include:**
- Alert details (rule ID, severity, timestamp)
- Affected system information
- Timeline of events
- Investigation steps taken
- Evidence collected (screenshots, logs)
- Root cause analysis
- Impact assessment
- Recommendations

**Use the template:** `REPORT-TEMPLATE-INCIDENT.md`

---

### 2. Screenshots (`screenshots/`)

**When to capture:**
- Every alert you investigate
- Dashboard views showing detections
- Sysmon event details
- MITRE ATT&CK coverage
- Network activity
- Process trees
- Any visual evidence

**Naming Convention:**
```
YYYY-MM-DD-description-context.png

Examples:
2026-01-12-rule-92057-alert.png
2026-01-12-powershell-sysmon-event.png
2026-01-12-mitre-attack-dashboard.png
2026-01-12-agent-status-overview.png
```

**Best Practices:**
- Use high resolution (not blurry)
- Crop to relevant information
- Add annotations if needed (arrows, highlights)
- Name descriptively so you know what it is later
- Reference screenshots in incident reports

**Tools:**
- Windows: Win+Shift+S (Snipping Tool)
- Full screen: Win+PrtScn
- Annotation: Paint, Greenshot, ShareX

---

### 3. Weekly Summaries (`weekly-summaries/`)

**When to create:**
- End of each week
- After major testing phases
- Monthly for portfolio updates

**Naming Convention:**
```
YYYY-WXX-weekly-summary.md
YYYY-MM-monthly-summary.md

Examples:
2026-W02-weekly-summary.md
2026-01-monthly-summary.md
```

**What to include:**
- Total alerts by severity
- New detections validated
- Attack simulations performed
- Configuration changes made
- Issues encountered and resolved
- Lessons learned
- Next week's goals

**Template:**
```markdown
# Weekly Security Summary - Week XX, YYYY

## Overview
- **Period:** YYYY-MM-DD to YYYY-MM-DD
- **Total Alerts:** X high, Y medium, Z low
- **Incidents Investigated:** X
- **Detection Rate:** XX%

## Key Activities
1. Activity 1
2. Activity 2

## Notable Detections
- Detection 1: Description
- Detection 2: Description

## Challenges & Solutions
- Challenge: Solution

## Metrics
| Metric | Count |
|--------|-------|
| Total Events | X |
| High-Severity Alerts | X |
| Investigations Completed | X |

## Next Week Goals
- [ ] Goal 1
- [ ] Goal 2
```

---

### 4. Detection Validation (`detection-validation/`)

**When to create:**
- After testing each MITRE ATT&CK technique
- When validating detection rule effectiveness
- Quarterly detection coverage reviews

**Naming Convention:**
```
YYYY-MM-DD-TXXXX-technique-name.md

Examples:
2026-01-12-T1059-001-powershell-validation.md
2026-01-12-T1087-account-discovery-validation.md
```

**What to include:**
- MITRE ATT&CK technique details
- Attack commands used
- Expected detection
- Actual detection results
- Rule IDs triggered
- Alert quality assessment
- Coverage gaps identified

**Template:**
```markdown
# Detection Validation - T1059.001 PowerShell

## Technique Information
- **ID:** T1059.001
- **Name:** Command and Scripting Interpreter: PowerShell
- **Tactic:** Execution
- **Date Tested:** YYYY-MM-DD

## Test Scenarios

### Scenario 1: Encoded Command
**Command:** `powershell.exe -EncodedCommand "dwBoAG8AYQBtAGkA"`
**Expected:** High-severity alert
**Result:** ✅ Detected - Rule 92057, Level 12
**Response Time:** <3 seconds

### Scenario 2: Execution Policy Bypass
**Command:** `powershell.exe -ExecutionPolicy Bypass -Command "whoami"`
**Expected:** Medium-severity alert
**Result:** ✅ Detected - Sysmon Event ID 1
**Response Time:** <5 seconds

## Detection Coverage
- ✅ Encoded commands: Covered
- ✅ Policy bypass: Covered
- ⚠️ Remote scripts: Partially covered
- ❌ Fileless execution: Not covered

## Recommendations
1. Add detection for Invoke-Expression
2. Monitor for System.Management.Automation logs
3. Alert on multiple PowerShell spawns

## Overall Assessment
**Coverage:** 75%
**Quality:** Excellent
**False Positives:** None observed
```

---

## 🎨 Screenshot Organization

### By Date
```
screenshots/
├── 2026-01-12-rule-92057-alert.png
├── 2026-01-12-sysmon-event-details.png
├── 2026-01-12-mitre-attack-coverage.png
└── 2026-01-13-brute-force-detection.png
```

### By Category (Alternative)
```
screenshots/
├── alerts/
│   ├── high-severity/
│   └── medium-severity/
├── dashboards/
├── sysmon-events/
└── network-activity/
```

**Choose one method and stick with it!**

---

## 📊 Quick Reference - What to Document

### Every Alert Investigation
- [ ] Screenshot of alert
- [ ] Alert JSON export
- [ ] Related Sysmon events
- [ ] Timeline of activity
- [ ] Your analysis
- [ ] Determination (malicious/benign)
- [ ] Actions taken

### Every Attack Simulation
- [ ] Attack command used
- [ ] Expected MITRE technique
- [ ] Detection result (yes/no)
- [ ] Alert details if detected
- [ ] Screenshots of detection
- [ ] Time to detect
- [ ] Quality of alert context

### Weekly Summary
- [ ] Number of alerts by severity
- [ ] Incidents investigated
- [ ] New detections validated
- [ ] Configuration changes
- [ ] Challenges resolved
- [ ] Skills learned
- [ ] Next week's goals

---

## 💡 Pro Tips

### For Job Interviews
Bring printed incident reports or have them ready on your laptop. When asked "tell me about a security incident you investigated," you can show:
- Professional documentation
- Systematic investigation methodology
- Evidence collection
- Clear communication
- Recommendations

### For Portfolio
Select your 3-5 best incident reports that show:
1. Different attack techniques
2. Varying complexity levels
3. Clear problem-solving process
4. Professional documentation quality

### For Learning
After each investigation, add a "Lessons Learned" section:
- What new technique did I learn?
- What would I do differently?
- What additional detection do I need?
- What skills do I need to develop?

---

## 📋 Checklist - Starting a New Investigation

1. **Open Template**
   ```bash
   cp reports/REPORT-TEMPLATE-INCIDENT.md reports/incident-reports/YYYY-MM-DD-INC-XXX-description.md
   ```

2. **Capture Evidence Immediately**
   - Screenshot the alert
   - Export alert JSON
   - Copy related log entries

3. **Fill Out Template Sections**
   - Start with Executive Summary (write this last)
   - Document timeline as events occur
   - Take screenshots of each investigation step
   - Note commands you run

4. **Complete Investigation**
   - Determine root cause
   - Assess impact
   - Make recommendations
   - Close incident

5. **Save Everything**
   - Incident report in `incident-reports/`
   - Screenshots in `screenshots/`
   - Raw logs if needed
   - Git commit your work

---

## 🚀 Example Workflow

**You see an alert in the dashboard:**

```bash
# 1. Take screenshot
Win+Shift+S → Save as 2026-01-13-alert-XYZ.png

# 2. Create incident report from template
cd "K:\PROJECTS\SOC home lab"
cp reports/REPORT-TEMPLATE-INCIDENT.md reports/incident-reports/2026-01-13-INC-004-suspicious-process.md

# 3. Investigate and document
# Fill out template as you investigate
# Add screenshots
# Export alert JSON

# 4. On Ubuntu, gather evidence
sudo tail -100 /var/ossec/logs/alerts/alerts.json | jq '.' > /tmp/alert-evidence.json
# Copy to reports folder

# 5. Complete report and commit
git add reports/
git commit -m "Add incident report INC-004: Suspicious process execution"
git push
```

---

## 📈 Monthly Review

At the end of each month, review your reports folder:

```bash
# Count incidents investigated
ls -1 reports/incident-reports/ | wc -l

# Check detection coverage
grep -r "MITRE ATT&CK" reports/incident-reports/ | wc -l

# Review lessons learned
grep -r "Lessons Learned" reports/incident-reports/
```

Create a monthly summary highlighting:
- Total incidents: X
- MITRE techniques detected: Y
- Detection gaps identified: Z
- Skills developed: [list]
- Next month's focus: [areas]

---

## 📌 Remember

**Good documentation:**
- Helps you learn
- Shows professional skills
- Builds your portfolio
- Helps others learn from your work
- Demonstrates systematic thinking

**Every investigation is portfolio material!**

Even if it's a false positive or test activity, documenting it professionally shows employers you can:
- Investigate systematically
- Communicate clearly
- Think critically
- Work independently
- Build evidence

---

**Start documenting every alert you investigate - future you will thank you! 🎯**
