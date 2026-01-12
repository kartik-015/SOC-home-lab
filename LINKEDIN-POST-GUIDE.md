# LinkedIn Post - SOC Home Lab Project

## 📱 SHORT VERSION (Recommended for LinkedIn Feed)

```
🔒 Completed My SOC Home Lab with Wazuh SIEM!

Just finished building a fully operational Security Operations Center home lab for hands-on threat detection and incident response training.

🎯 What I Built:
✅ Wazuh 4.14.1 SIEM on Ubuntu Server 24.04
✅ Windows 10 endpoint with Sysmon 15.15 integration
✅ Kali Linux attack simulation platform
✅ Multi-system network (192.168.137.0/24)

🔍 Attack Scenarios Tested:
• Encoded PowerShell execution (T1059.001)
• Account discovery with net.exe (T1087)
• EICAR malware simulation
• Execution policy bypass attacks

📊 Detection Results:
🎯 100% detection rate on simulated attacks
🚨 High-severity alert (Level 12) for base64-encoded PowerShell
📈 34+ Sysmon events captured and analyzed
🗺️ Mapped detections to MITRE ATT&CK framework

🛠️ Tech Stack:
Wazuh SIEM | Sysmon | Ubuntu Server | VMware | Kali Linux | OpenSearch | PowerShell

💡 Key Learnings:
• SIEM deployment and configuration
• Enhanced Windows telemetry with Sysmon
• Log correlation and threat hunting
• MITRE ATT&CK technique mapping
• Agent management and troubleshooting

The lab is now fully operational and ready for advanced threat simulations, custom detection rules, and incident response playbook development.

🔗 Project repo: [Your GitHub Link]

#CyberSecurity #SIEM #Wazuh #ThreatDetection #SOC #InfoSec #BlueTeam #SecurityAnalyst #HomeLab #MITREATTnCK
```

---

## 📱 DETAILED VERSION (For LinkedIn Article or Project Portfolio)

```
🔒 Building a SOC Home Lab: My Journey with Wazuh SIEM

Over the past few days, I completed an intensive hands-on project building a fully functional Security Operations Center (SOC) home lab. This project gave me deep practical experience with enterprise-level security monitoring, threat detection, and incident response.

═══════════════════════════════════════

🏗️ THE ARCHITECTURE

I designed a multi-system virtualized environment:

🖥️ Ubuntu Server 24.04 (192.168.137.10)
→ Wazuh Manager 4.14.1 (central analysis)
→ OpenSearch Indexer (log storage)
→ Web Dashboard (visualization)

💻 Windows 10 Endpoint (192.168.137.20)
→ Wazuh Agent 4.8.0
→ Sysmon 15.15 (SwiftOnSecurity config)
→ Monitored victim machine

🐧 Kali Linux (192.168.137.30)
→ Attack simulation platform
→ Nmap, Hydra, penetration testing tools

🌐 Network: VMware Workstation with ICS networking

═══════════════════════════════════════

🎯 ATTACK SIMULATIONS & DETECTIONS

I simulated real-world attack techniques and validated detection coverage:

1️⃣ ENCODED POWERSHELL EXECUTION
Command: powershell.exe -EncodedCommand [base64]
✅ Detected: Rule 92057, Severity Level 12 (HIGH)
✅ MITRE: T1059.001 (Command and Scripting Interpreter)

2️⃣ ACCOUNT DISCOVERY (Reconnaissance)
Commands: net user, net localgroup, whoami /priv
✅ Detected: Multiple discovery activity alerts
✅ MITRE: T1087 (Account Discovery)

3️⃣ MALWARE SIMULATION
Created EICAR test file via PowerShell
✅ Detected: Sysmon Event ID 11 (File Creation)
✅ Suspicious file location flagged

4️⃣ EXECUTION POLICY BYPASS
PowerShell with -ExecutionPolicy Bypass flag
✅ Detected: Command-line arguments captured
✅ Full process tree logged

═══════════════════════════════════════

📊 RESULTS & METRICS

🎯 Detection Rate: 100% on simulated attacks
📈 Events Logged: 34+ Sysmon events in 24 hours
🚨 High-Severity Alerts: 8 alerts (Level ≥10)
🗺️ MITRE Coverage: T1059.001, T1087, T1082, T1204.002
⚡ Response Time: Real-time alerting (<2 minutes)

═══════════════════════════════════════

💡 KEY TECHNICAL SKILLS DEVELOPED

✅ SIEM Deployment & Configuration
→ Multi-component installation (Manager, Indexer, Dashboard)
→ Agent registration and authentication key management
→ Service orchestration and monitoring

✅ Enhanced Logging & Telemetry
→ Sysmon configuration for advanced Windows visibility
→ Event log collection strategy (Application, Security, System)
→ Log format optimization (eventchannel vs eventlog)

✅ Threat Detection & Analysis
→ Dashboard filtering and threat hunting queries
→ Alert correlation and severity assessment
→ False positive analysis

✅ MITRE ATT&CK Framework
→ Mapping detected activities to techniques
→ Understanding adversary tactics and procedures
→ Building detection coverage matrix

✅ Troubleshooting & Problem Solving
→ Network connectivity issues (NAT → ICS migration)
→ Agent connection problems (IP configuration)
→ Log collection gaps (Sysmon format correction)

═══════════════════════════════════════

🚀 NEXT STEPS

Phase 6: Advanced Attack Simulations
→ Network port scanning detection
→ RDP brute force with Hydra
→ Lateral movement techniques

Phase 7: Custom Detection Rules
→ Frequency-based alerting
→ Behavioral analysis rules
→ Automated response actions

Phase 8: Reporting & Dashboards
→ Executive-level security metrics
→ Incident response playbooks
→ Automated weekly reports

═══════════════════════════════════════

🎓 CHALLENGES OVERCOME

❌ Problem: VMware NAT networking failed to provide internet
✅ Solution: Switched to Windows ICS, reconfigured entire network

❌ Problem: Agent showed "Never connected" status
✅ Solution: Corrected manager IP in ossec.conf from old network

❌ Problem: Sysmon logs not appearing in dashboard
✅ Solution: Changed log format from 'eventlog' to 'eventchannel'

═══════════════════════════════════════

🛠️ TECHNOLOGY STACK

Security: Wazuh SIEM 4.14.1, Sysmon 15.15, OpenSearch
OS: Ubuntu Server 24.04, Windows 10 Pro, Kali Linux
Virtualization: VMware Workstation
Languages: PowerShell, Bash
Tools: Nmap, Hydra, net.exe, whoami

═══════════════════════════════════════

📚 LEARNING OUTCOMES

This project significantly deepened my understanding of:
• How enterprise SOCs operate
• The importance of enhanced logging (Sysmon)
• Real-world attack patterns and detection strategies
• The gap between theory and practical implementation
• Troubleshooting complex multi-system environments

I'm now ready to contribute to security operations teams with hands-on SIEM experience, threat detection expertise, and practical incident response skills.

🔗 Full Project Documentation: [GitHub Link]
📸 Screenshots and Architecture Diagrams: [See attached images]

═══════════════════════════════════════

#CyberSecurity #SIEM #Wazuh #BlueTeam #ThreatHunting #SecurityOperations #InfoSec #SOC #SecurityAnalyst #ThreatDetection #IncidentResponse #MITREATTnCK #Sysmon #HomeLab #OpenSearch #SecurityMonitoring #DefensiveSecurity
```

---

## 📸 SCREENSHOT STRATEGY FOR LINKEDIN

### Required Screenshots (Attach to Post)

**Image 1: Dashboard Overview** 📊
- Shows agent status (Active)
- Alert counts and statistics
- Professional-looking main interface
→ Caption: "Wazuh Dashboard - Real-time Security Monitoring"

**Image 2: High-Severity Alert** 🚨
- Rule 92057 (Encoded PowerShell)
- Severity Level 12 highlighted
- MITRE T1059.001 visible
→ Caption: "High-Severity Detection - Encoded PowerShell Execution (Level 12)"

**Image 3: MITRE ATT&CK Coverage** 🗺️
- MITRE ATT&CK view showing detected techniques
- Multiple technique IDs highlighted
- Coverage visualization
→ Caption: "MITRE ATT&CK Framework Mapping - 100% Detection Rate"

**Image 4: Sysmon Event Details** 🔍
- Expanded event showing full command line
- Process tree and parent process
- Rich telemetry data
→ Caption: "Sysmon Enhanced Telemetry - Complete Process Visibility"

### Optional (For Portfolio/Article)
- Architecture diagram (create in draw.io or Lucidchart)
- Network topology visualization
- Alert timeline showing attack sequence
- Agent management interface

---

## 🎬 POSTING STRATEGY

### Best Time to Post
- **Tuesday-Thursday** between **8-10 AM** or **12-2 PM** (your timezone)
- Avoid Monday mornings and Friday afternoons
- Lunch hours tend to get good engagement

### Hashtag Strategy
**Primary (High Traffic):**
#CyberSecurity #InfoSec #SIEM #BlueTeam

**Specific (Targeted):**
#Wazuh #Sysmon #ThreatDetection #SOC #SecurityAnalyst

**Trending (Visibility):**
#MITREATTnCK #ThreatHunting #SecurityOperations #IncidentResponse

**Community:**
#HomeLab #CyberSecurityProjects #SecurityMonitoring #DefensiveSecurity

**Total:** 12-15 hashtags (LinkedIn optimal range)

### Engagement Tips
1. Tag relevant companies/people:
   - @Wazuh (official account)
   - Your mentors or instructors
   - Cybersecurity influencers you follow

2. Respond to comments promptly (within 2-4 hours)

3. Share to relevant LinkedIn Groups:
   - Cybersecurity groups
   - SOC/SIEM communities
   - Career development groups

4. Cross-post to Twitter/X with thread format

---

## ✅ PRE-POSTING CHECKLIST

Before publishing on LinkedIn:

**Content:**
- [ ] Proofread for typos and grammar
- [ ] Verify all technical details are accurate
- [ ] Ensure screenshots don't contain sensitive info (IPs are fine for lab)
- [ ] Add your GitHub repo link (if created)

**Visual:**
- [ ] Screenshots are high-resolution (not blurry)
- [ ] Images are cropped professionally
- [ ] Add captions/annotations to highlight key points
- [ ] Consider creating a cover image with project title

**Profile:**
- [ ] Update LinkedIn headline to include "Security Analyst" or "SOC Analyst"
- [ ] Add "Wazuh SIEM" to skills section
- [ ] Add project to "Projects" section of LinkedIn profile
- [ ] Update "About" section to mention hands-on security experience

**Engagement:**
- [ ] Prepare 3-5 responses to common questions:
  - "How long did this take?" → 3 days intensive
  - "What was the hardest part?" → Network troubleshooting and Sysmon integration
  - "Resources for beginners?" → Wazuh documentation, SOC lab guides

---

## 📧 FOLLOW-UP CONTENT IDEAS

### Week 1: Behind the Scenes
Post about specific challenge you solved (Sysmon configuration issue)

### Week 2: Technical Deep Dive
Share detailed post about one specific detection (Rule 92057)

### Week 3: Lessons Learned
Post about key takeaways and career relevance

### Week 4: Next Phase
Announce Phase 6 (advanced attacks) and ask for suggestions

---

**🎯 GOAL:** Position yourself as a hands-on security professional with practical SIEM experience

**📈 EXPECTED ENGAGEMENT:** 50-200 reactions, 10-30 comments (depending on network size)

**🔗 NEXT ACTION:** Upload screenshots, copy short version, and post during peak hours!
