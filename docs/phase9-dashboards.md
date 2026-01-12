# PHASE 9: Dashboards & Visualization

## Overview

This phase creates comprehensive Kibana dashboards for SOC monitoring, alert analysis, and security visualization.

---

## Objectives

1. ✅ Create security alerts overview dashboard
2. ✅ Create failed login attempts dashboard
3. ✅ Create top attacker IPs visualization
4. ✅ Create alert trends dashboard
5. ✅ Create severity distribution dashboard

---

## Prerequisites

- [ ] Phase 3 complete (Kibana installed and accessible)
- [ ] Phase 5 complete (Detection rules active)
- [ ] Phase 4 complete (Test attacks executed)
- [ ] Access to Kibana at `http://192.168.56.10:5601`

---

## Part 1: Kibana Dashboard Basics

### Accessing Kibana

1. Open browser: `http://192.168.56.10:5601`
2. Login with Wazuh credentials
3. Navigate to **Wazuh** → **Discover** (for viewing logs)
4. Navigate to **Kibana** → **Dashboard** (for creating dashboards)

### Understanding Kibana Visualizations

**Visualization Types:**
- **Data Table**: Tabular data display
- **Line Chart**: Time series data
- **Bar Chart**: Comparative data
- **Pie Chart**: Distribution data
- **Metric**: Single value display
- **Gauge**: Progress indicators

---

## Part 2: Dashboard 1 - Security Alerts Overview

### Visualization 2.1: Total Alerts Count

**Create Metric Visualization:**

1. **Kibana** → **Visualize Library** → **Create visualization** → **Metric**
2. **Index Pattern**: `wazuh-alerts-*`
3. **Metrics**:
   - Aggregation: Count
   - Custom Label: "Total Alerts"
4. **Save**: "Total Alerts Count"

### Visualization 2.2: Alerts by Severity (Pie Chart)

**Create Pie Chart:**

1. **Create visualization** → **Pie**
2. **Index Pattern**: `wazuh-alerts-*`
3. **Buckets**:
   - **Split Slices**:
     - Aggregation: Terms
     - Field: `rule.level`
     - Size: 10
     - Custom Label: "Severity Level"
4. **Save**: "Alerts by Severity"

### Visualization 2.3: Alerts Over Time (Line Chart)

**Create Line Chart:**

1. **Create visualization** → **Line**
2. **Index Pattern**: `wazuh-alerts-*`
3. **Metrics**:
   - Aggregation: Count
4. **Buckets**:
   - **X-axis**:
     - Aggregation: Date Histogram
     - Field: `@timestamp`
     - Interval: Auto
   - **Split Series**:
     - Aggregation: Terms
     - Field: `rule.level`
     - Size: 5
5. **Save**: "Alerts Over Time"

### Dashboard 2.4: Create Security Alerts Overview Dashboard

1. **Kibana** → **Dashboard** → **Create dashboard**
2. **Add** → Select all visualizations:
   - Total Alerts Count
   - Alerts by Severity
   - Alerts Over Time
3. Arrange visualizations
4. **Save** → Name: "Security Alerts Overview"

**Kibana Query (for filtering):**
```
rule.level: >=7
```

---

## Part 3: Dashboard 2 - Failed Login Attempts

### Visualization 3.1: Failed Logins Over Time

**Create Line Chart:**

1. **Create visualization** → **Line**
2. **Index Pattern**: `wazuh-alerts-*`
3. **Query**: `rule.id: (100010 OR 100011 OR 100012)`
4. **Metrics**: Count
5. **Buckets**:
   - **X-axis**: Date Histogram on `@timestamp`
6. **Save**: "Failed Logins Over Time"

### Visualization 3.2: Top Source IPs for Failed Logins

**Create Bar Chart:**

1. **Create visualization** → **Vertical Bar**
2. **Index Pattern**: `wazuh-alerts-*`
3. **Query**: `rule.id: (100010 OR 100011 OR 100012)`
4. **Metrics**: Count
5. **Buckets**:
   - **X-axis**: Terms on `data.win.eventdata.ipAddress.keyword`
     - Size: 10
     - Order: Top, Descending
6. **Save**: "Top Source IPs - Failed Logins"

### Visualization 3.3: Failed Logins by Rule

**Create Data Table:**

1. **Create visualization** → **Data Table**
2. **Index Pattern**: `wazuh-alerts-*`
3. **Query**: `rule.id: (100010 OR 100011 OR 100012)`
4. **Metrics**: Count
5. **Buckets**:
   - **Split Rows**:
     - Aggregation: Terms
     - Field: `rule.description.keyword`
     - Size: 10
     - Order: Top, Descending
6. **Save**: "Failed Logins by Rule"

### Dashboard 3.4: Create Failed Login Dashboard

1. **Create dashboard**
2. **Add** visualizations:
   - Failed Logins Over Time
   - Top Source IPs - Failed Logins
   - Failed Logins by Rule
3. **Save**: "Failed Login Attempts Dashboard"

---

## Part 4: Dashboard 3 - Top Attacker IPs

### Visualization 4.1: Top Attacker IPs (All Attacks)

**Create Bar Chart:**

1. **Create visualization** → **Vertical Bar**
2. **Index Pattern**: `wazuh-alerts-*`
3. **Metrics**: Count
4. **Buckets**:
   - **X-axis**: Terms on `data.win.eventdata.ipAddress.keyword`
     - Size: 10
     - Order: Top, Descending
     - Missing: "Unknown"
5. **Save**: "Top Attacker IPs"

### Visualization 4.2: Attack Types by IP

**Create Data Table:**

1. **Create visualization** → **Data Table**
2. **Index Pattern**: `wazuh-alerts-*`
3. **Metrics**: Count
4. **Buckets**:
   - **Split Rows**:
     - Aggregation: Terms
     - Field: `data.win.eventdata.ipAddress.keyword`
     - Size: 10
   - **Split Rows** (sub-bucket):
     - Aggregation: Terms
     - Field: `rule.description.keyword`
     - Size: 5
5. **Save**: "Attack Types by IP"

### Visualization 4.3: Attacker Activity Timeline

**Create Line Chart:**

1. **Create visualization** → **Line**
2. **Index Pattern**: `wazuh-alerts-*`
3. **Metrics**: Count
4. **Buckets**:
   - **X-axis**: Date Histogram on `@timestamp`
   - **Split Series**: Terms on `data.win.eventdata.ipAddress.keyword`
     - Size: 5
5. **Save**: "Attacker Activity Timeline"

### Dashboard 4.4: Create Top Attacker IPs Dashboard

1. **Create dashboard**
2. **Add** visualizations:
   - Top Attacker IPs
   - Attack Types by IP
   - Attacker Activity Timeline
3. **Save**: "Top Attacker IPs Dashboard"

---

## Part 5: Dashboard 4 - Alert Trends

### Visualization 5.1: Alert Trend (Last 24 Hours)

**Create Line Chart:**

1. **Create visualization** → **Line**
2. **Index Pattern**: `wazuh-alerts-*`
3. **Time Range**: Last 24 hours
4. **Metrics**: Count
5. **Buckets**:
   - **X-axis**: Date Histogram on `@timestamp`
     - Interval: 1 hour
6. **Save**: "Alert Trend 24h"

### Visualization 5.2: Alert Trend by Attack Type

**Create Line Chart:**

1. **Create visualization** → **Line**
2. **Index Pattern**: `wazuh-alerts-*`
3. **Metrics**: Count
4. **Buckets**:
   - **X-axis**: Date Histogram on `@timestamp`
   - **Split Series**: Terms on `rule.groups`
     - Size: 10
5. **Save**: "Alert Trend by Attack Type"

### Visualization 5.3: Alert Volume by Hour of Day

**Create Bar Chart:**

1. **Create visualization** → **Vertical Bar**
2. **Index Pattern**: `wazuh-alerts-*`
3. **Metrics**: Count
4. **Buckets**:
   - **X-axis**: Date Histogram on `@timestamp`
     - Interval: 1 hour
     - Custom Label: "Hour"
5. **Save**: "Alerts by Hour of Day"

### Dashboard 5.4: Create Alert Trends Dashboard

1. **Create dashboard**
2. **Add** visualizations:
   - Alert Trend 24h
   - Alert Trend by Attack Type
   - Alerts by Hour of Day
3. **Save**: "Alert Trends Dashboard"

---

## Part 6: Dashboard 5 - Severity Distribution

### Visualization 6.1: Severity Distribution (Pie Chart)

**Create Pie Chart:**

1. **Create visualization** → **Pie**
2. **Index Pattern**: `wazuh-alerts-*`
3. **Buckets**:
   - **Split Slices**: Terms on `rule.level`
     - Size: 10
4. **Save**: "Severity Distribution"

### Visualization 6.2: Critical Alerts Count

**Create Metric:**

1. **Create visualization** → **Metric**
2. **Index Pattern**: `wazuh-alerts-*`
3. **Query**: `rule.level: >=10`
4. **Metrics**: Count
   - Custom Label: "Critical Alerts"
5. **Save**: "Critical Alerts Count"

### Visualization 6.3: Severity Over Time

**Create Area Chart:**

1. **Create visualization** → **Area**
2. **Index Pattern**: `wazuh-alerts-*`
3. **Metrics**: Count
4. **Buckets**:
   - **X-axis**: Date Histogram on `@timestamp`
   - **Split Series**: Terms on `rule.level`
     - Size: 5
5. **Save**: "Severity Over Time"

### Dashboard 6.4: Create Severity Distribution Dashboard

1. **Create dashboard**
2. **Add** visualizations:
   - Severity Distribution
   - Critical Alerts Count
   - Severity Over Time
3. **Save**: "Severity Distribution Dashboard"

---

## Part 7: Dashboard 6 - Attack Type Overview

### Visualization 7.1: Attack Types (Pie Chart)

**Create Pie Chart:**

1. **Create visualization** → **Pie**
2. **Index Pattern**: `wazuh-alerts-*`
3. **Buckets**:
   - **Split Slices**: Terms on `rule.groups`
     - Size: 10
4. **Save**: "Attack Types Distribution"

### Visualization 7.2: Top Attack Rules

**Create Data Table:**

1. **Create visualization** → **Data Table**
2. **Index Pattern**: `wazuh-alerts-*`
3. **Metrics**: Count
4. **Buckets**:
   - **Split Rows**: Terms on `rule.description.keyword`
     - Size: 10
     - Order: Top, Descending
5. **Save**: "Top Attack Rules"

### Visualization 7.3: Attack Timeline

**Create Timeline Visualization:**

1. **Create visualization** → **Timelion**
2. **Query**:
   ```
   .es(index=wazuh-alerts-*, timefield=@timestamp, metric=count).label("All Attacks")
   ```
3. **Save**: "Attack Timeline"

### Dashboard 7.4: Create Attack Type Overview Dashboard

1. **Create dashboard**
2. **Add** visualizations:
   - Attack Types Distribution
   - Top Attack Rules
   - Attack Timeline
3. **Save**: "Attack Type Overview Dashboard"

---

## Part 8: Wazuh Pre-built Dashboards

### Using Wazuh Security Dashboard

**Wazuh provides pre-built dashboards:**

1. Navigate to: **Wazuh** → **Security Events**
2. **Security Events** dashboard shows:
   - Security alerts
   - Agent status
   - Rule distribution
   - Alert details

### Using Wazuh Agents Dashboard

1. Navigate to: **Wazuh** → **Agents**
2. View agent status and health
3. Monitor agent connectivity

---

## Part 9: Dashboard Best Practices

### Dashboard Design Tips

1. **Keep it Simple**: Focus on key metrics
2. **Time Context**: Include time range selectors
3. **Refresh Intervals**: Set appropriate auto-refresh
4. **Color Coding**: Use consistent colors for severity
5. **Filters**: Add common filters (agent, severity, etc.)

### Dashboard Filters

**Add Global Filters to Dashboards:**

1. In dashboard, click **Add filter**
2. Common filters:
   - `rule.level: >=7` (High severity only)
   - `agent.name: windows7-victim`
   - `rule.id: 100010`
   - Time range: Last 24 hours

---

## Part 10: Dashboard Export and Sharing

### Export Dashboard

**Export Dashboard JSON:**

1. Open dashboard
2. Click **Share** → **Permalink** (for sharing)
3. Or export via Kibana API (advanced)

### Save Dashboard Images

**Screenshot dashboards for documentation:**

1. Arrange dashboard
2. Set appropriate time range
3. Take screenshot
4. Save to `reports/screenshots/dashboards/`

---

## Dashboard Summary

| Dashboard Name | Purpose | Key Visualizations |
|----------------|---------|-------------------|
| Security Alerts Overview | General alert monitoring | Total alerts, severity pie, trend |
| Failed Login Attempts | Authentication failures | Failed logins over time, top IPs |
| Top Attacker IPs | Attacker identification | Top IPs, attack types, timeline |
| Alert Trends | Trend analysis | 24h trend, by attack type, by hour |
| Severity Distribution | Risk assessment | Severity pie, critical count, trend |
| Attack Type Overview | Attack categorization | Attack types, top rules, timeline |

---

## Validation Checklist

- [ ] All dashboards created
- [ ] Visualizations displaying correctly
- [ ] Data populating from alerts
- [ ] Filters configured
- [ ] Dashboards saved
- [ ] Screenshots captured
- [ ] Dashboard documentation complete

---

## Next Steps

**Phase 9 Status**: ✅ **COMPLETE**

**Ready for**: Phase 10 - Documentation & Portfolio

---

**Phase 9 Documentation Complete**

