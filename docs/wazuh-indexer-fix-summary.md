# Wazuh Indexer Fix Summary

**Date:** January 10, 2026  
**Status:** ✅ RESOLVED

## Issues Identified and Fixed

### 1. Certificate Path Configuration Error
**Problem:** Double path in certificate configuration  
- Error: `/etc/wazuh-indexer//etc/wazuh-indexer/certs/root-ca.pem`
- Root Cause: Absolute paths incorrectly configured in `opensearch.yml`

**Fix Applied:**
```bash
sudo sed -i 's|pemcert_filepath: /etc/wazuh-indexer/certs/|pemcert_filepath: certs/|g' /etc/wazuh-indexer/opensearch.yml
sudo sed -i 's|pemkey_filepath: /etc/wazuh-indexer/certs/|pemkey_filepath: certs/|g' /etc/wazuh-indexer/opensearch.yml
```

### 2. Memory Locking Bootstrap Check Failure
**Problem:** `memory locking requested for opensearch process but memory is not locked`

**Fix Applied:**
```bash
sudo sed -i 's/bootstrap.memory_lock: true/bootstrap.memory_lock: false/' /etc/wazuh-indexer/opensearch.yml
```

### 3. Network Binding Issue
**Problem:** Service only listening on `192.168.56.10`, not accessible via localhost

**Fix Applied:**
```bash
sudo sed -i 's/network.host: 192.168.56.10/network.host: 0.0.0.0/' /etc/wazuh-indexer/opensearch.yml
```

## Final Status

✅ **Service Running:** Active and healthy  
✅ **Cluster Status:** Yellow (normal for single-node cluster)  
✅ **Network:** Listening on all interfaces (port 9200)  
✅ **API Responding:** Successfully authenticated and responding  

**Cluster Details:**
- Name: `wazuh-cluster`
- Node: `wazuh-1`
- OpenSearch Version: `2.19.3`
- Active Shards: 9
- Health: Yellow (expected for single-node setup)

## Verification Commands

```bash
# Check service status
sudo systemctl status wazuh-indexer

# Test API connection
curl -k -u admin:admin https://localhost:9200

# Check cluster health
curl -k -u admin:admin https://localhost:9200/_cluster/health?pretty
```

## Notes
- Yellow cluster status is normal for single-node deployments (no replica shards)
- Service is configured to start on boot
- All certificate paths now use relative paths from `/etc/wazuh-indexer/`
