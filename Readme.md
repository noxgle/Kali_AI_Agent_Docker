[![Kali AI Agent Docker Container](https://img.youtube.com/vi/nvP8HA_LTek/0.jpg)](https://youtu.be/nvP8HA_LTek)


# Kali AI Agent Docker Container

This project provides a Docker container for Kali Linux with SSH access, allowing secure remote connections for penetration testing and security research. Additionally, the container includes a terminal-based AI agent and chat tool installed from [noxgle/term_agent](https://github.com/noxgle/term_agent.git), providing enhanced AI-assisted interaction within the terminal environment.

## Direct Installation from GHCR

For a quick setup without cloning the repository, you can pull and run the pre-built Docker image directly from GitHub Container Registry:

```bash
# Pull the pre-built image
docker pull ghcr.io/noxgle/kali_ai_agent_docker:main

# Run the container
docker run -d \
  --name kali-ssh-container \
  --restart unless-stopped \
  --privileged \
  -p 2222:22 \
  ghcr.io/noxgle/kali_ai_agent_docker:main
```

After running, you can connect to the container via SSH:
```bash
ssh root@localhost -p 2222
```

**Note:** The default SSH password for root is `123456` (for development/testing purposes). For production use, consider changing the password after first login.

## Cloning the Repository

To get started, clone the repository:

```bash
git clone https://github.com/noxgle/Kali_AI_Agent_Docker.git
cd Kali_AI_Agent_Docker
```

This project uses `docker-compose` to build and run the Docker image. The SSH password for root is set to `123456` by default in the Dockerfile (for development/testing purposes).

**Note:** The default password is `123456`. For production use, consider modifying the password in the Dockerfile or using Docker build secrets for better security.


To build the Docker image:
```bash
docker-compose build
```

To run the Docker container:
```bash
docker-compose up -d
```

After running, you can connect to the container via SSH:
```bash
ssh root@localhost -p 2222
```

## Post-Installation Configuration

Immediately after the first SSH login (or by using `docker exec -it <container_name> bash`), you need to configure the terminal AI agent. Edit the configuration file located at `/term_agent/.env` and specify the API details with your own API key. The terminal AI agent supports Google GenAI, ChatGPT (OpenAI), and Ollama APIs - select and configure the API you prefer for authentication.
