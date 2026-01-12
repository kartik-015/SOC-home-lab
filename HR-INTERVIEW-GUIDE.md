# SOC Home Lab Project - HR Interview Guide

**Project:** Wazuh SIEM Home Lab Implementation  
**Author:** Kartik  
**Date:** January 2026  
**Duration:** 3 Days (January 10-12, 2026)

---

## Executive Summary

Built a fully operational Security Operations Center (SOC) home lab featuring Wazuh SIEM for real-time threat detection, log analysis, and incident response. Deployed a three-system virtualized environment achieving 100% detection on simulated MITRE ATT&CK techniques including encoded PowerShell execution (T1059.001) and account discovery (T1087). Demonstrated practical SIEM deployment, enhanced Windows logging with Sysmon, agent management, and professional troubleshooting skills directly applicable to SOC analyst roles.

---

## 30-Second Elevator Pitch

"I built a fully operational Security Operations Center home lab using Wazuh SIEM to gain hands-on experience with enterprise threat detection. I deployed a three-system virtualized environment with Ubuntu Server running the SIEM platform, Windows 10 as a monitored endpoint with enhanced Sysmon logging, and Kali Linux for attack simulation. I successfully detected 100% of simulated attacks including encoded PowerShell execution and account discovery techniques, mapping them to the MITRE ATT&CK framework. The project taught me SIEM deployment, log analysis, agent management, and real-world troubleshooting skills that directly apply to SOC analyst work."

---

## 2-Minute Detailed Overview

"I designed and built a comprehensive SOC home lab to develop practical security monitoring skills. The architecture included three virtual machines on a 192.168.137.0/24 network - an Ubuntu Server 24.04 running Wazuh SIEM 4.14.1 with all components including the manager, OpenSearch indexer, and web dashboard; a Windows 10 Pro endpoint with Wazuh agent and Sysmon 15.15 for enhanced telemetry; and a Kali Linux system for attack simulation.

The project had significant technical challenges. My initial Wazuh deployment failed with certificate and service errors, so I made the strategic decision to do a fresh installation rather than spend days debugging, which taught me valuable lessons about when to rebuild versus repair. I also encountered network connectivity issues where VMware NAT wasn't working, so I pivoted to using Windows Internet Connection Sharing, completely reconfiguring the network topology. The biggest learning moment came when Sysmon logs weren't appearing in the SIEM - I discovered the agent configuration needed 'eventchannel' format instead of 'eventlog' for modern Windows event channels, which was critical for visibility.

Once operational, I simulated real-world attacks including encoded PowerShell execution, account discovery using net.exe commands, EICAR malware testing, and execution policy bypass. The SIEM detected all attacks with high-severity alerts, including a Level 12 alert for base64-encoded PowerShell matching MITRE ATT&CK technique T1059.001. I captured 34+ Sysmon events and successfully mapped detections to multiple MITRE techniques including T1087 for account discovery. The project gave me hands-on experience with SIEM architecture, threat detection, log correlation, agent troubleshooting, and the MITRE ATT&CK framework - all skills directly applicable to SOC analyst positions."

---

## Project Architecture

### System Components

| System | IP Address | Role | Specifications |
|--------|------------|------|----------------|
| Ubuntu Server 24.04 | 192.168.137.10 | Wazuh SIEM Server | 8GB RAM, 4 CPU cores, 60GB disk |
| Windows 10 Pro | 192.168.137.20 | Monitored Endpoint | 4GB RAM, 2 CPU cores, 40GB disk |
| Kali Linux | 192.168.137.30 | Attack Simulation | 2GB RAM, 2 CPU cores, 20GB disk |
| Windows 11 Host | 192.168.137.1 | Gateway/ICS Provider | Physical host machine |

### Technology Stack

**Security Monitoring:**
- Wazuh SIEM 4.14.1 (Manager + Indexer + Dashboard)
- Wazuh Agent 4.8.0
- Sysmon 15.15 (SwiftOnSecurity configuration)
- OpenSearch (log storage and indexing)

**Operating Systems:**
- Ubuntu Server 24.04 LTS
- Windows 10 Pro
- Kali Linux

**Virtualization:**
- VMware Workstation
- Windows Internet Connection Sharing (ICS)

**Attack Simulation Tools:**
- PowerShell (encoded commands, policy bypass)
- net.exe (account discovery)
- EICAR (malware testing)
- Nmap (network scanning)

---

## Key Achievements & Metrics

### Detection Results
- **Detection Rate:** 100% on all simulated attacks
- **High-Severity Alerts:** 8 critical alerts (Level ≥10)
- **Total Sysmon Events:** 34+ captured in 24 hours
- **Response Time:** Real-time alerting (<2 minutes)
- **MITRE Coverage:** T1059.001, T1087, T1082, T1204.002

### Notable Detections
- **Rule 92057:** Encoded PowerShell execution (Severity Level 12)
- **Multiple net.exe alerts:** Account discovery activities
- **Sysmon Event ID 1:** Process creation with full command lines
- **Sysmon Event ID 11:** File creation (EICAR test)
- **Sysmon Event ID 3:** Network connections captured

---

## Technical Challenges & Solutions

### Challenge 1: Initial Deployment Failure
**Problem:** First Wazuh installation had certificate path errors, authentication failures, and service connectivity issues.

**Solution:** Made strategic decision to delete VM and perform fresh Ubuntu Server 24.04 installation rather than debug legacy issues. Completed clean installation in 2 hours versus potentially days of troubleshooting.

**Learning:** Sometimes starting fresh is more efficient than debugging. This decision-making skill applies to production environments where rebuild vs. repair tradeoffs exist.

### Challenge 2: Network Connectivity Issues
**Problem:** VMware NAT (192.168.100.x) failed to provide internet access to VMs, preventing Wazuh installation script from downloading packages.

**Solution:** Enabled Windows Internet Connection Sharing (ICS) on host machine's Ethernet adapter, sharing to VMnet1 adapter. Network automatically changed to 192.168.137.0/24. Reconfigured all VMs with static IPs and proper gateway/DNS settings.

**Learning:** Lab environments require networking flexibility. Developed skills in IP addressing, gateway configuration, DNS setup, and alternative networking strategies.

### Challenge 3: Agent Connectivity
**Problem:** Windows 10 Wazuh agent showed "Never connected" status in dashboard despite successful installation.

**Solution:** Discovered agent's ossec.conf file contained old manager IP (192.168.56.10) from initial network plan. Manually edited configuration file to correct IP (192.168.137.10), restarted agent service, achieved Active connection status immediately.

**Learning:** Agent connectivity is primary troubleshooting point in SIEM deployments. Configuration file accuracy is critical. Developed systematic troubleshooting approach: check service status → verify configuration → examine logs → test connectivity.

### Challenge 4: Sysmon Log Collection
**Problem:** Sysmon 15.15 installed successfully on Windows 10 and generating events in Event Viewer, but logs not appearing in Wazuh dashboard.

**Solution:** Researched Wazuh documentation and discovered agent configuration used 'eventlog' format for Sysmon channel. Modern Windows event channels require 'eventchannel' format. Changed single line in ossec.conf from:
```xml
<log_format>eventlog</log_format>
```
to:
```xml
<log_format>eventchannel</log_format>
```
Restarted agent, Sysmon events immediately flowed to SIEM.

**Learning:** Small configuration details have major impacts. Enhanced logging (Sysmon) provides 10x more visibility than standard Windows logs. Documentation reading and research skills critical for cybersecurity work.

---

## Attack Simulations & Detections

### Attack 1: Encoded PowerShell Execution
**Command Executed:**
```powershell
powershell.exe -EncodedCommand "dwBoAG8AYQBtAGkA"
```

**Detection:**
- Rule 92057: "Powershell.exe spawned a powershell process which executed a base64 encoded command"
- Severity Level: 12 (HIGH - Critical)
- MITRE ATT&CK: T1059.001 (PowerShell - Command and Scripting Interpreter)
- Total Events: 8 PowerShell execution alerts

**Analysis:** Adversaries use encoded PowerShell to hide malicious commands from defenders. Wazuh's behavioral detection identified the suspicious process spawning pattern and base64 encoding, generating immediate high-severity alert.

### Attack 2: Account Discovery
**Commands Executed:**
```powershell
net user Administrator
net localgroup Administrators
whoami /priv
```

**Detection:**
- Multiple "net.exe account discovery command" alerts
- "Discovery activity executed" alerts
- MITRE ATT&CK: T1087.001/002 (Account Discovery: Local/Domain)
- Command-line arguments fully captured via Sysmon

**Analysis:** Reconnaissance phase where attacker enumerates accounts and privileges. Wazuh detected the suspicious use of native Windows utilities for information gathering.

### Attack 3: EICAR Malware Simulation
**Command Executed:**
```powershell
'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' | Out-File C:\Users\Public\malware-test.exe -Encoding ASCII
```

**Detection:**
- Sysmon Event ID 11 (File Creation)
- "Powershell process created an executable file in Windows root folder"
- Full file path and hash captured
- MITRE ATT&CK: T1204.002 (User Execution: Malicious File)

**Analysis:** EICAR is industry-standard test for malware detection. Sysmon's file creation monitoring with hash logging provides forensic evidence for investigation.

### Attack 4: Execution Policy Bypass
**Command Executed:**
```powershell
powershell.exe -ExecutionPolicy Bypass -Command "Get-Process | Select-Object -First 5"
```

**Detection:**
- Sysmon Event ID 1 (Process Creation)
- Full command-line arguments logged including "-ExecutionPolicy Bypass" flag
- Parent process tracked (cmd.exe → powershell.exe)

**Analysis:** Adversaries bypass PowerShell execution policy to run unsigned scripts. Complete command-line logging enables detection of this common defense evasion technique.

---

## Skills Demonstrated

### Technical Skills

**SIEM Operations:**
- Multi-component SIEM deployment (Manager, Indexer, Dashboard)
- Agent deployment and lifecycle management
- Manual agent registration and key exchange
- Service orchestration and monitoring
- Password and certificate management
- Log source configuration and optimization

**Log Analysis:**
- Dashboard filtering and search queries
- Time-based correlation
- Alert severity assessment
- Event investigation and pivoting
- Command-line log analysis (grep, tail, jq)
- Raw JSON log interpretation

**Enhanced Logging:**
- Sysmon deployment and configuration
- SwiftOnSecurity configuration implementation
- Event channel vs. event log format understanding
- Log source troubleshooting
- Event ID mapping (1=Process, 3=Network, 11=File, 22=DNS)

**Threat Detection:**
- Attack simulation and validation
- Detection rule analysis
- False positive assessment
- MITRE ATT&CK framework mapping
- Technique identification (T1059, T1087, T1082, T1204)
- Coverage gap analysis

**System Administration:**
- Linux server administration (Ubuntu)
- Windows endpoint management
- PowerShell scripting and execution
- Service management (systemctl, Get-Service)
- Configuration file editing
- SSH remote administration

**Networking:**
- IP addressing and subnetting
- Static IP configuration (Linux and Windows)
- Gateway and DNS configuration
- Internet Connection Sharing setup
- Network troubleshooting
- Connectivity testing and validation

**Virtualization:**
- VMware Workstation administration
- VM creation and resource allocation
- Virtual network configuration
- Snapshot and backup concepts
- Multi-system environment orchestration

### Soft Skills

**Problem Solving:**
- Systematic troubleshooting methodology
- Root cause analysis
- Component isolation for failure identification
- Strategic decision-making (rebuild vs. repair)
- Alternative solution development

**Research & Learning:**
- Technical documentation reading
- Independent problem research
- Online resource utilization
- Community forum navigation
- Continuous learning mindset

**Persistence & Adaptability:**
- Working through deployment failures
- Pivoting strategies when approaches fail
- Maintaining momentum through challenges
- Learning from mistakes
- Project completion despite obstacles

**Communication:**
- Technical documentation writing
- Replication guide creation for knowledge transfer
- Professional portfolio development
- Project articulation for non-technical audiences
- Clear explanation of complex concepts

**Time Management:**
- Breaking complex projects into phases
- Setting realistic timelines
- Knowing when to pause and resume fresh
- Prioritizing critical path activities
- Balancing learning depth vs. project progress

---

## HR Interview Questions & Answers

### Q: "Walk me through this project from start to finish."

**Answer:** "I started by researching enterprise SIEM solutions and chose Wazuh because it's open-source, actively maintained, and used by many organizations. I designed a three-VM architecture and began deploying Wazuh on Ubuntu Server. When I hit technical issues with the initial installation, I made the decision to start fresh rather than debug for days. I configured the network using Internet Connection Sharing from my Windows host, deployed all three virtual machines with static IP addressing, and installed Wazuh using the official all-in-one installation script. I then deployed the Windows agent, configured Sysmon for enhanced logging, and spent significant time troubleshooting why Sysmon events weren't appearing - ultimately discovering the configuration format issue. Once everything was operational, I simulated various attack techniques and validated that the SIEM detected them correctly, mapping results to the MITRE ATT&CK framework. Finally, I documented everything professionally for my portfolio and GitHub."

---

### Q: "What was the biggest challenge you faced?"

**Answer:** "The biggest technical challenge was getting Sysmon logs to flow into Wazuh. Sysmon was installed and generating events in Windows, and the Wazuh agent was connected and collecting standard event logs, but Sysmon events weren't appearing. I systematically troubleshot this by checking Windows Event Viewer to confirm Sysmon was working, checking Wazuh server logs to see if events were being received, and examining the agent configuration file. I discovered the issue was a single configuration parameter - the log format was set to 'eventlog' instead of 'eventchannel' for modern Windows event channels. This taught me that in complex systems, small configuration details can have major impacts on functionality. The bigger lesson was learning to troubleshoot methodically by isolating each component until I found the failure point."

---

### Q: "Why did you choose this project?"

**Answer:** "I chose this project because SOC analyst roles consistently require hands-on SIEM experience, and I wanted to develop those skills practically rather than just theoretically. Reading about log analysis and threat detection isn't the same as actually deploying a multi-component SIEM, troubleshooting real issues, and validating detections work. I specifically chose Wazuh because it's used in production environments, has an active community, and integrating it with Sysmon gives visibility comparable to expensive commercial solutions. The project also let me develop adjacent skills like Linux administration, Windows security, networking, and virtualization - all critical for security roles. Most importantly, I can now speak credibly in interviews about SIEM deployment challenges, agent management, log collection strategies, and threat detection validation because I've actually done it."

---

### Q: "What would you do differently if you started over?"

**Answer:** "Knowing what I know now, I would start with the fresh Ubuntu installation from the beginning rather than trying to fix a broken existing installation - that would have saved several hours. I would also plan the network architecture more carefully upfront, testing internet connectivity before deploying the SIEM. I'd research the Sysmon eventchannel configuration requirement beforehand rather than discovering it through troubleshooting. However, I also recognize that encountering and solving these problems was valuable learning - in a production SOC, you'll face unexpected issues, and my experience troubleshooting them gives me confidence I can handle similar problems. The project taught me not just how things work when they go right, but how to diagnose and fix them when they don't."

---

### Q: "What did you learn that you didn't expect?"

**Answer:** "I didn't expect how much difference enhanced logging makes. Standard Windows event logs give you basic information, but Sysmon provides command-line arguments, process trees, network connections, file hashes, and DNS queries - exponentially more context for investigations. I also didn't anticipate how much time goes into troubleshooting connectivity and configuration versus the actual security analysis work. In movies, security analysts are always hunting threats, but in reality, you spend significant time ensuring log sources are working, agents are connected, and configurations are correct. That operational foundation work is critical because you can't detect threats if you're not collecting the right logs. This gives me realistic expectations about what SOC work actually involves day-to-day."

---

### Q: "How does this project relate to the SOC Analyst role?"

**Answer:** "This project directly mirrors SOC analyst responsibilities. SOC analysts work with SIEM platforms to monitor alerts, investigate suspicious activity, and determine if incidents require escalation. I gained hands-on experience with all of these. I deployed and configured the SIEM platform, which is relevant for understanding how it works under the hood. I troubleshot agent connectivity issues, which is a common daily task. I analyzed security alerts, determined their severity, and investigated the underlying events - that's core SOC work. I used the MITRE ATT&CK framework to understand what adversary techniques were detected, which is how SOC teams communicate about threats. I worked with both command-line tools and dashboards, which reflects the real environment. The main difference is in a SOC I'd be analyzing alerts from hundreds or thousands of endpoints rather than just one, but the fundamental skills of log analysis, alert triage, and incident investigation are identical."

---

### Q: "Tell me about a time you had to make a difficult technical decision."

**Answer:** "When my initial Wazuh deployment had certificate errors and service failures, I faced a decision: spend potentially days debugging the complex authentication and certificate chain issues, or delete everything and start fresh. I had already invested several hours trying different fixes - editing opensearch.yml, regenerating certificates, troubleshooting dashboard routing. The difficult part was accepting the sunk cost and changing approaches. I evaluated that a fresh installation would take 2-3 hours versus unknown time debugging legacy configuration problems. I made the strategic decision to rebuild, documented what went wrong for learning purposes, and completed the fresh installation successfully in under 2 hours. This taught me that sometimes the quickest path forward is starting from a known-good state rather than trying to fix an unknown-bad state. It's a lesson I imagine applies frequently in production environments where you balance repair time versus replacement time."

---

### Q: "Describe your troubleshooting methodology."

**Answer:** "I use a systematic approach to isolate problems. When Sysmon logs weren't appearing, I didn't randomly change things. First, I verified Sysmon was actually running on Windows using Get-Service. Second, I checked Windows Event Viewer to confirm Sysmon was generating events locally. Third, I checked the Wazuh agent service status to ensure it was running. Fourth, I examined the agent's own logs for errors. Fifth, I checked the Wazuh server to see if any events were being received. Sixth, I reviewed the agent configuration file line by line. This systematic approach isolated the problem to the configuration file, specifically the log format parameter. I then researched the correct format for Windows event channels, implemented the fix, tested, and validated. This methodology - verify each component individually, check logs at each stage, isolate the failure point, research the solution, implement, test, validate - works for any complex system troubleshooting."

---

### Q: "What's your experience with the MITRE ATT&CK framework?"

**Answer:** "Through this project, I gained practical hands-on experience mapping real security events to MITRE ATT&CK techniques. When I simulated encoded PowerShell execution, Wazuh mapped it to T1059.001 - PowerShell under the Command and Scripting Interpreter tactic. My account discovery commands with net.exe mapped to T1087 - Account Discovery under the Discovery tactic. I understand MITRE ATT&CK serves multiple purposes: it's a common language for security teams to communicate about threats without ambiguity, it helps organizations assess detection coverage across the attack lifecycle, and it provides context for understanding where specific alerts fit in an adversary's playbook. In this lab, I achieved coverage for T1059.001, T1087, T1082, and T1204.002, but I also learned which techniques I'm not detecting - like T1003 for credential dumping, which would require additional logging sources. This framework helps prioritize what detection capabilities to build next."

---

### Q: "How do you stay current with cybersecurity developments?"

**Answer:** "This project itself demonstrates my approach to continuous learning - building hands-on labs to understand tools practically. Beyond this, I follow security researchers on Twitter and LinkedIn, read threat reports from vendors like CrowdStrike and Mandiant, participate in cybersecurity subreddits and Discord communities, and work through platforms like TryHackMe and HackTheBox. For this project specifically, I read Wazuh's official documentation, followed their installation guides, researched Sysmon configurations from SwiftOnSecurity's GitHub, and learned about MITRE ATT&CK from their website. When I encountered problems, I searched GitHub issues, Stack Overflow, and Wazuh's community forums. I believe in learning by doing - reading about security concepts is important, but actually deploying tools, breaking things, and fixing them creates deeper understanding that sticks with you."

---

### Q: "What interests you about working in a SOC?"

**Answer:** "I'm drawn to SOC work because it combines technical depth with real-world impact. Every alert you investigate could be a real threat to the organization. I'm fascinated by the detective work involved - taking disparate log sources, correlating events, building timelines, and determining what actually happened versus false positives. This project gave me a taste of that when I investigated my simulated PowerShell attack - seeing the full process tree, understanding the parent-child relationships, examining the command-line arguments, and correlating it with network and file events. I also appreciate that SOC work requires continuous learning because attack techniques evolve constantly. What excites me most is being part of an organization's defensive front line, working with a team of analysts who learn from each other, and knowing the work directly protects people and data. This home lab was my way of preparing to contribute meaningfully from day one."

---

### Q: "Where do you see yourself in 2-3 years?"

**Answer:** "In 2-3 years, I see myself as a proficient SOC analyst with deep expertise in threat detection and incident response. I want to become the team member who can handle complex investigations involving multiple attack vectors, someone who understands not just how to use the SIEM but how to tune it for better detection coverage. I'd like to develop skills in threat hunting - proactively searching for threats rather than just responding to alerts. I'm interested in specializing in either advanced persistent threat detection or cloud security, depending on the organization's needs and where I find my skills are most valuable. Long-term, I see myself moving toward a threat intelligence analyst or detection engineer role where I can create custom detection rules and improve the team's overall capabilities. But first, I want to master the fundamentals in a SOC environment, learn from experienced analysts, and contribute to protecting the organization while developing those advanced skills."

---

### Q: "What questions do you have for me?"

**Prepared Questions:**

1. "Can you walk me through what a typical day looks like for a SOC analyst on your team? I'm curious about the balance between monitoring alerts, investigation work, and other responsibilities."

2. "What SIEM platform does your SOC use, and what's your approach to tuning detection rules to reduce false positives while maintaining coverage?"

3. "How does your team handle knowledge sharing and continuous learning? I'm eager to learn from experienced analysts."

4. "What are the most common types of threats or alerts your SOC handles, and how does that influence what skills are most important for new analysts to develop?"

5. "What would success look like for someone in this role in the first 3-6 months?"

6. "How does your SOC integrate with incident response? Do analysts participate in full incident handling or primarily focus on detection and escalation?"

7. "What opportunities exist for specialization or career growth within the security team?"

---

## 5-Minute Comprehensive Story

"I built this SOC home lab because I wanted to go beyond theoretical knowledge and gain real hands-on experience with enterprise security monitoring systems before entering the workforce. The goal was to create a functional Security Operations Center environment where I could deploy a professional SIEM, integrate enhanced logging, simulate attacks, and develop actual threat detection and analysis skills.

The architecture I designed included three virtual machines running on VMware Workstation. The core was an Ubuntu Server 24.04 with 8GB RAM and 4 CPU cores running Wazuh SIEM 4.14.1 in an all-in-one deployment. This included the Wazuh Manager for log analysis and correlation, the OpenSearch-based indexer for log storage and searching, and the web dashboard for visualization and investigation. I deployed a Windows 10 Pro endpoint as the monitored system with the Wazuh agent 4.8.0 and Sysmon 15.15 using SwiftOnSecurity's configuration for enhanced Windows telemetry. Finally, I set up Kali Linux as an attack simulation platform with tools like nmap and Hydra. All systems communicated on a 192.168.137.0/24 network.

The project had several significant challenges that taught me valuable problem-solving skills. Initially, I attempted to deploy Wazuh on an existing Ubuntu installation but encountered certificate path errors, authentication failures, and service connectivity issues. After spending several hours troubleshooting, I made the strategic decision to delete the VM and start with a fresh Ubuntu Server installation. This taught me an important lesson about when it's more efficient to rebuild than to debug legacy configuration issues - something I imagine happens in production environments too.

My second major challenge was networking. I originally planned to use VMware's NAT networking on the 192.168.56.0/24 subnet, but the VMs couldn't reach the internet, which prevented the Wazuh installation script from downloading required packages. I researched alternatives and discovered I could enable Internet Connection Sharing on my Windows 11 host machine, which changed the network range to 192.168.137.0/24. I had to reconfigure all three VMs with static IP addresses - Ubuntu at .10, Windows at .20, and Kali at .30 - and set proper gateway and DNS settings. This taught me the importance of network planning and having backup strategies in security lab environments.

The third critical challenge came after I installed the Wazuh agent on Windows 10 - it showed 'Never connected' status in the dashboard. Through troubleshooting, I discovered the agent's ossec.conf file still had the old manager IP address from my initial network plan. I manually edited the configuration to point to 192.168.137.10, restarted the agent service, and it immediately connected and showed Active status. This reinforced that agent connectivity is often the first troubleshooting point in SIEM deployments.

The most valuable technical learning came with Sysmon integration. I installed Sysmon 15.15 with the SwiftOnSecurity configuration, which provides detailed process creation, network connections, file creation, and DNS query events - far beyond standard Windows event logs. However, these events weren't appearing in my Wazuh dashboard. After researching the Wazuh documentation and checking log files on the Ubuntu server, I discovered the agent configuration was using 'eventlog' format for the Sysmon channel, but modern Windows event channels require 'eventchannel' format. Once I corrected this single line in ossec.conf and restarted the agent, Sysmon events immediately started flowing. This taught me that configuration details matter enormously - a single incorrect parameter can prevent entire log sources from working.

With the infrastructure operational, I moved to attack simulation and detection validation. I executed encoded PowerShell commands using the -EncodedCommand parameter, which is a common technique adversaries use to hide malicious code. Wazuh immediately generated a high-severity alert - Rule 92057 with severity level 12 - detecting that PowerShell spawned another PowerShell process with base64-encoded commands. I ran account discovery commands like 'net user Administrator' and 'net localgroup Administrators,' which Wazuh detected as reconnaissance activity. I created an EICAR test file to simulate malware, and Sysmon Event ID 11 captured the file creation with full path and hash information. I also tested execution policy bypass techniques, and all command-line arguments were captured in the logs.

What was particularly exciting was seeing how these detections mapped to the MITRE ATT&CK framework. The encoded PowerShell was mapped to T1059.001 - PowerShell under the Command and Scripting Interpreter tactic. The account discovery commands mapped to T1087 - Account Discovery. This gave me practical understanding of how security teams communicate about threats using a common framework and how to assess detection coverage across the attack lifecycle. I achieved 100% detection on all simulated attacks, captured over 34 Sysmon events, and generated 8 high-severity alerts.

Beyond the technical skills, this project taught me important soft skills. I learned when to persist with troubleshooting versus when to change strategies, as with my decision to do a fresh installation. I learned to break down complex problems systematically - when Sysmon logs weren't appearing, I checked service status, then Windows event logs, then Wazuh agent logs, then configuration files, isolating where the failure occurred. I learned to read documentation effectively and search for solutions, which is critical in cybersecurity where you constantly encounter new tools and techniques. I also documented everything thoroughly, creating comprehensive guides so others could replicate my lab, which reflects the documentation skills needed in security operations.

The practical skills I gained directly translate to SOC analyst responsibilities. I can deploy and configure enterprise SIEM systems, manage security agents across Windows and Linux endpoints, troubleshoot connectivity and log collection issues, analyze security alerts with proper context, correlate events across multiple log sources, map detections to industry frameworks like MITRE ATT&CK, and investigate suspicious activity using both command-line tools and dashboards. I'm comfortable working in both Linux and Windows environments, which is essential for heterogeneous enterprise networks.

I documented the entire project professionally, including full technical documentation, a replication guide for others who want to build the lab, and LinkedIn post templates. I pushed everything to GitHub to demonstrate not just technical skills but also the ability to communicate and share knowledge. This project represents about 20 hours of intensive hands-on work over three days, but the learning continues as I plan to add advanced attack simulations, custom detection rules, and automated response capabilities in the next phases.

What excites me most about this project is that it bridges the gap between theoretical knowledge and practical application. I didn't just read about SIEM systems - I deployed one, troubleshot it, and used it to detect real attack techniques. I understand the challenges security analysts face daily: agents that won't connect, log sources that need configuration, alerts that require investigation, and the constant need to validate that your detections actually work. This hands-on experience makes me confident I can contribute effectively to your SOC team from day one, and I'm eager to apply these skills in a professional environment where I can continue learning from experienced practitioners."

---

## Closing Statement

This project represents my commitment to developing practical, job-ready skills rather than just collecting certifications. I invested significant time not just in building the lab, but in troubleshooting real problems, documenting my work professionally, and ensuring I understood the 'why' behind each configuration. I can deploy and troubleshoot SIEM systems, analyze security alerts, investigate incidents using multiple log sources, and communicate findings using industry frameworks. But more importantly, I've proven I can learn independently, solve complex problems systematically, and persist through challenges - qualities I know your SOC team values. I'm excited about the opportunity to apply these skills in a professional environment where I can continue growing while contributing to your organization's security mission.

---

## Project Links & Resources

**GitHub Repository:** [Your GitHub Link]  
**LinkedIn Profile:** [Your LinkedIn]  
**Project Documentation:** Available in repository  
**Replication Guide:** Step-by-step instructions for others  

---

## Contact Information

**Name:** Kartik  
**Email:** [Your Email]  
**LinkedIn:** [Your Profile]  
**GitHub:** [Your Username]  
**Project Date:** January 2026  

---

**End of Document**
