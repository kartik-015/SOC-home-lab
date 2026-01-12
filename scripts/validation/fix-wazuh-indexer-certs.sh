#!/bin/bash
# Fix Wazuh Indexer Certificate Path Issue

echo "=== Fixing Wazuh Indexer Certificate Paths ==="

# First, let's check the current opensearch.yml
echo -e "\n[1/4] Checking current opensearch.yml certificate paths..."
sudo grep -E "pemcert|pemkey|pemtrust" /etc/wazuh-indexer/opensearch.yml

# Check if certificates exist
echo -e "\n[2/4] Verifying certificates exist..."
ls -la /etc/wazuh-indexer/certs/

# Fix the certificate paths - replace absolute paths with relative paths
echo -e "\n[3/4] Fixing certificate paths in opensearch.yml..."
sudo sed -i 's|pemcertfilepath: /etc/wazuh-indexer/|pemcertfilepath: |g' /etc/wazuh-indexer/opensearch.yml
sudo sed -i 's|pemkeyfilepath: /etc/wazuh-indexer/|pemkeyfilepath: |g' /etc/wazuh-indexer/opensearch.yml
sudo sed -i 's|pemtrustedcas_filepath: /etc/wazuh-indexer/|pemtrustedcas_filepath: |g' /etc/wazuh-indexer/opensearch.yml

# Also fix any double slashes
sudo sed -i 's|/etc/wazuh-indexer//etc/wazuh-indexer/|/etc/wazuh-indexer/|g' /etc/wazuh-indexer/opensearch.yml

echo -e "\n[4/4] Verifying fixed paths..."
sudo grep -E "pemcert|pemkey|pemtrust" /etc/wazuh-indexer/opensearch.yml

echo -e "\n=== Fix applied! Now restart the service ==="
