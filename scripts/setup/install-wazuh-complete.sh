#!/bin/bash
# Complete Wazuh Installation with admin:admin credentials
# Run this on your SIEM server (siemserver)

set -e

echo "=========================================="
echo "Wazuh Complete Installation Script"
echo "Credentials: admin / admin"
echo "=========================================="

# Step 1: Add Wazuh Repository
echo -e "\n[1/6] Adding Wazuh repository..."
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg

if ! grep -q "packages.wazuh.com" /etc/apt/sources.list.d/wazuh.list 2>/dev/null; then
    echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee -a /etc/apt/sources.list.d/wazuh.list
fi

# Step 2: Install Wazuh Manager
echo -e "\n[2/6] Installing Wazuh Manager..."
sudo apt update
sudo apt install wazuh-manager -y

sudo systemctl daemon-reload
sudo systemctl enable wazuh-manager
sudo systemctl start wazuh-manager

echo "Waiting for Wazuh Manager to start..."
sleep 5

# Step 3: Install Wazuh Dashboard
echo -e "\n[3/6] Installing Wazuh Dashboard..."
sudo apt install wazuh-dashboard -y

# Step 4: Configure Dashboard Certificates
echo -e "\n[4/6] Configuring Dashboard certificates..."
sudo mkdir -p /etc/wazuh-dashboard/certs

# Generate dashboard certificates
sudo openssl genrsa -out /etc/wazuh-dashboard/certs/dashboard-key.pem 2048
sudo openssl req -new -x509 -key /etc/wazuh-dashboard/certs/dashboard-key.pem \
    -out /etc/wazuh-dashboard/certs/dashboard.pem -days 365 \
    -subj "/CN=192.168.56.10"

# Copy root CA from indexer
sudo cp /etc/wazuh-indexer/certs/root-ca.pem /etc/wazuh-dashboard/certs/

# Fix permissions
sudo chown -R wazuh-dashboard:wazuh-dashboard /etc/wazuh-dashboard/certs/
sudo chmod 600 /etc/wazuh-dashboard/certs/dashboard-key.pem
sudo chmod 644 /etc/wazuh-dashboard/certs/dashboard.pem
sudo chmod 644 /etc/wazuh-dashboard/certs/root-ca.pem

# Step 5: Configure Dashboard Settings
echo -e "\n[5/6] Configuring Wazuh Dashboard..."

# Backup original config
sudo cp /etc/wazuh-dashboard/opensearch_dashboards.yml /etc/wazuh-dashboard/opensearch_dashboards.yml.backup

# Create new configuration
sudo tee /etc/wazuh-dashboard/opensearch_dashboards.yml > /dev/null <<EOF
# Wazuh Dashboard Configuration
server.host: "0.0.0.0"
server.port: 443
opensearch.hosts: ["https://localhost:9200"]
opensearch.ssl.verificationMode: certificate
opensearch.username: "admin"
opensearch.password: "admin"
opensearch.requestHeadersWhitelist: ["securitytenant","Authorization"]
opensearch_security.multitenancy.enabled: false
opensearch_security.readonly_mode.roles: ["kibana_read_only"]
server.ssl.enabled: true
server.ssl.certificate: "/etc/wazuh-dashboard/certs/dashboard.pem"
server.ssl.key: "/etc/wazuh-dashboard/certs/dashboard-key.pem"
opensearch.ssl.certificateAuthorities: ["/etc/wazuh-dashboard/certs/root-ca.pem"]
uiSettings.overrides.defaultRoute: "/app/wazuh"
EOF

# Fix permissions on config
sudo chown wazuh-dashboard:wazuh-dashboard /etc/wazuh-dashboard/opensearch_dashboards.yml
sudo chmod 640 /etc/wazuh-dashboard/opensearch_dashboards.yml

# Step 6: Start Dashboard
echo -e "\n[6/6] Starting Wazuh Dashboard..."
sudo systemctl daemon-reload
sudo systemctl enable wazuh-dashboard
sudo systemctl start wazuh-dashboard

echo -e "\nWaiting for services to start..."
sleep 10

# Verification
echo -e "\n=========================================="
echo "Installation Complete!"
echo "=========================================="
echo ""
echo "Service Status:"
echo "---------------"
sudo systemctl status wazuh-indexer --no-pager | head -5
echo ""
sudo systemctl status wazuh-manager --no-pager | head -5
echo ""
sudo systemctl status wazuh-dashboard --no-pager | head -5
echo ""
echo "=========================================="
echo "Access Information:"
echo "=========================================="
echo "Dashboard URL: https://192.168.56.10"
echo "Username: admin"
echo "Password: admin"
echo "=========================================="
echo ""
echo "Verify services are running:"
echo "  sudo systemctl status wazuh-indexer"
echo "  sudo systemctl status wazuh-manager"
echo "  sudo systemctl status wazuh-dashboard"
echo ""
echo "Check logs if issues:"
echo "  sudo tail -f /var/log/wazuh-indexer/wazuh-cluster.log"
echo "  sudo tail -f /var/ossec/logs/ossec.log"
echo "  sudo tail -f /var/log/wazuh-dashboard/wazuh-dashboard.log"
