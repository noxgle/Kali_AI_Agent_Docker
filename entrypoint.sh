#!/bin/bash

echo "=========================================="
echo " VAULT 3000 TERMINAL AGENT ON KALI LINUX  " 
echo "=========================================="

# Setup aliases in .bashrc
echo "Setting up aliases..."
#echo "" >> /root/.bashrc
echo "# Vault 3000 Docker aliases" >> /root/.bashrc
echo "alias ask=\"/term_agent/.venv/bin/python /term_agent/term_ask.py\"" >> /root/.bashrc
echo "alias ag=\"/term_agent/.venv/bin/python /term_agent/term_ag.py\"" >> /root/.bashrc
echo "alias prom=\"/term_agent/.venv/bin/python /term_agent/PromptCreator.py\"" >> /root/.bashrc

# Source .bashrc to activate aliases immediately
source /root/.bashrc

# Check if .env file exists
if [ -f "/term_agent/.env" ]; then
    echo "✓ .env file found and mounted"
else
    echo "! Warning: .env file not found. Please mount your .env file with API keys"
    echo "  Example: docker-compose up -d"
fi

# Display helpful information
echo ""
echo "SSH Details:"
echo "  Username: root"
echo "  Password: 123456"
echo "  Port: 22 (mapped to host port 2222)"
echo ""
echo "Available Commands:"
echo "  ag              - Start term_ag.py AI agent"
echo "  ask             - Start term_ask.py chat mode"
echo "  prom            - Start PromptCreator.py"
echo ""
echo "Connection Example:"
echo "  ssh root@localhost -p 2222"
echo "  ssh root@<host-ip> -p 2222"
echo ""
echo "=========================================="
echo "Starting SSH daemon..."
echo "=========================================="

exec /usr/sbin/sshd -D
