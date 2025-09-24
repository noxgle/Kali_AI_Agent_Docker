FROM kalilinux/kali-rolling
ARG SSH_PASSWORD
LABEL maintainer="AI Agent"


# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt update && apt upgrade -y && \
    apt install -y kali-linux-headless openssh-server sudo locales git python3 python3-pip python3-venv nano && \
    rm -rf /var/lib/apt/lists/*

# Install locales and generate pl_PL.UTF-8
RUN echo "pl_PL.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen pl_PL.UTF-8

ENV LANG pl_PL.UTF-8
ENV LANGUAGE pl_PL:en
ENV LC_ALL pl_PL.UTF-8

# Generate SSH host keys
RUN ssh-keygen -A

# Create SSH directory
RUN mkdir -p /var/run/sshd

# Allow root login and password authentication (for testing purposes)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Change password for root user
RUN echo "root:$SSH_PASSWORD" | chpasswd


RUN bash -c "git clone https://github.com/noxgle/term_agent.git && \
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

# Command to run SSH daemon when container starts
#CMD ["/usr/sbin/sshd", "-D"]

# Copy entrypoint script and make it executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
