#!/bin/bash
# Wazuh Indexer Diagnostic and Fix Script

echo "======================================"
echo "Wazuh Indexer Diagnostic Script"
echo "======================================"

echo -e "\n[1/7] Checking journalctl logs..."
sudo journalctl -xeu wazuh-indexer.service --no-pager -n 50

echo -e "\n[2/7] Checking wazuh-indexer log file..."
if [ -f /var/log/wazuh-indexer/wazuh-cluster.log ]; then
    sudo tail -n 50 /var/log/wazuh-indexer/wazuh-cluster.log
else
    echo "Log file not found"
fi

echo -e "\n[3/7] Checking system resources..."
echo "Memory:"
free -h
echo -e "\nDisk space:"
df -h /var/lib/wazuh-indexer 2>/dev/null || df -h /

echo -e "\n[4/7] Checking file permissions..."
sudo ls -la /var/lib/wazuh-indexer/ 2>/dev/null | head -15
sudo ls -la /etc/wazuh-indexer/ 2>/dev/null | head -10

echo -e "\n[5/7] Checking JVM settings..."
if [ -f /etc/wazuh-indexer/jvm.options ]; then
    echo "Current JVM heap settings:"
    sudo grep "^-Xm" /etc/wazuh-indexer/jvm.options
else
    echo "JVM options file not found"
fi

echo -e "\n[6/7] Checking opensearch.yml..."
if [ -f /etc/wazuh-indexer/opensearch.yml ]; then
    sudo grep -v "^#" /etc/wazuh-indexer/opensearch.yml | grep -v "^$"
else
    echo "opensearch.yml not found"
fi

echo -e "\n[7/7] Checking port availability..."
sudo netstat -tulpn | grep -E ":(9200|9300)" || echo "Ports 9200 and 9300 are available"

echo -e "\n======================================"
echo "Diagnostic complete!"
echo "======================================"
