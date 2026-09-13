#!/bin/bash

echo "=========================================="
echo " ONE TERMINAL AGENT ON KALI LINUX       "
echo "=========================================="

# Setup PATH to include one venv bin
export PATH="/one/.venv/bin:$PATH"

# Source .bashrc to persist PATH
echo "export PATH=\"/one/.venv/bin:\$PATH\"" >> /root/.bashrc
source /root/.bashrc

# Check if API key is configured
if [ -z "$OPENAI_API_KEY" ] && [ -z "$ANTHROPIC_API_KEY" ] && [ -z "$GEMINI_API_KEY" ]; then
    echo "! Warning: No API key configured!"
    echo "  Set one of: OPENAI_API_KEY, ANTHROPIC_API_KEY, GEMINI_API_KEY"
    echo "  Example: docker-compose up -d -e OPENAI_API_KEY=sk-..."
else
    echo "✓ API key detected and configured"
fi

# Display helpful information
echo ""
echo "SSH Details:"
echo "  Username: root"
echo "  Password: 123456"
echo "  Port: 22 (mapped to host port 2222)"
echo ""
echo "Available Commands:"
echo "  one              - Start ONE terminal agent"
echo "  one run \"task\"   - Run a task headlessly"
echo "  one --mode tui   - Start TUI (textual UI)"
echo "  one --mode text  - Start REPL mode"
echo ""
echo "Configuration:"
echo "  Set API key via environment variable:"
echo "    OPENAI_API_KEY, ANTHROPIC_API_KEY, GEMINI_API_KEY,"
echo "    OLLAMA_BASE_URL (for local Ollama)"
echo ""
echo "Connection Example:"
echo "  ssh root@localhost -p 2222"
echo "  ssh root@<host-ip> -p 2222"
echo ""
echo "=========================================="
echo "Starting SSH daemon..."
echo "=========================================="

exec /usr/sbin/sshd -D
