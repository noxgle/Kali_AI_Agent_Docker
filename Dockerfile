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


RUN bash -c "git clone -b stable-1.2.4 https://github.com/noxgle/term_agent.git && \
    cd term_agent && \
    python3 -m venv .venv && \
    source .venv/bin/activate && \
    pip install --upgrade pip && \
    pip install --upgrade google-genai && \
    if [ -f requirements.txt ]; then \
        pip install -r requirements.txt; \
    fi && \
    cp .env.copy .env"


# Expose port 22 for SSH
EXPOSE 22

# Copy entrypoint script and make it executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
