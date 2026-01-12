#!/bin/bash
# Script to debug wazuh-indexer startup issues

echo "=== Checking journalctl logs for wazuh-indexer ==="
sudo journalctl -xeu wazuh-indexer.service --no-pager -n 100

echo -e "\n=== Checking wazuh-indexer log file ==="
sudo tail -n 100 /var/log/wazuh-indexer/wazuh-cluster.log

echo -e "\n=== Checking system resources ==="
echo "Memory:"
free -h
echo -e "\nDisk space:"
df -h /var/lib/wazuh-indexer

echo -e "\n=== Checking wazuh-indexer ownership and permissions ==="
ls -la /var/lib/wazuh-indexer/ | head -20
ls -la /etc/wazuh-indexer/ | head -20

echo -e "\n=== Checking opensearch.yml configuration ==="
sudo cat /etc/wazuh-indexer/opensearch.yml | grep -v "^#" | grep -v "^$"

echo -e "\n=== Checking JVM options ==="
sudo cat /etc/wazuh-indexer/jvm.options | grep -v "^#" | grep -v "^$"
