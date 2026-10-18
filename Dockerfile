FROM kalilinux/kali-rolling
LABEL maintainer="AI Agent"


# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt update && apt upgrade -y && \
    apt install -y kali-linux-headless openssh-server sudo locales git python3 python3-pip python3-venv nano && \
    rm -rf /var/lib/apt/lists/*

# Configure C.UTF-8 locale
RUN echo "C.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen C.UTF-8

# Set C.UTF-8 as default locale
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV LC_ALL=C.UTF-8

# Generate SSH host keys
RUN ssh-keygen -A

# Create SSH directory
RUN mkdir -p /var/run/sshd

# Allow root login and password authentication (for testing purposes)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Change password for root user
RUN echo "root:123456" | chpasswd


RUN bash -c "git clone --branch v0.1.85 --depth 1 https://github.com/noxgle/one.git && \
    cd one && \
    python3 -m venv .venv && \
    source .venv/bin/activate && \
    pip install --upgrade pip && \
    pip install -e '.[dev]'"

# Install the web-deepsearch MCP server after ONE. Pin the reviewed revision
# so builds keep using the same server source until this value is updated.
RUN git clone https://github.com/noxgle/mcp-web-deepsearch.git /mcp-web-deepsearch && \
    git -C /mcp-web-deepsearch checkout d9dc89e359cfed054954c068baa7decf271112ff && \
    python3 -m venv /mcp-web-deepsearch/.venv && \
    /mcp-web-deepsearch/.venv/bin/pip install --upgrade pip && \
    /mcp-web-deepsearch/.venv/bin/pip install --no-cache-dir -r /mcp-web-deepsearch/server/requirements.txt && \
    printf '%s\n' '#!/bin/sh' 'exec /mcp-web-deepsearch/.venv/bin/python /mcp-web-deepsearch/server/mcp_server.py "$@"' \
      > /usr/local/bin/web-deepsearch-mcp && \
    chmod +x /usr/local/bin/web-deepsearch-mcp && \
    mkdir -p /root/.config/one && \
    printf '%s\n' '{' '  "mcpServers": {' '    "web-deepsearch": {' '      "command": "/usr/local/bin/web-deepsearch-mcp",' '      "args": [],' '      "enabled": true' '    }' '  }' '}' \
      > /root/.config/one/settings.json && \
    chmod 600 /root/.config/one/settings.json


# Expose port 22 for SSH
EXPOSE 22

# Copy entrypoint script and make it executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
