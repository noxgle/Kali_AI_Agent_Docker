[![Kali AI Agent Docker Container](https://img.youtube.com/vi/nvP8HA_LTek/0.jpg)](https://youtu.be/nvP8HA_LTek)


# Kali AI Agent Docker Container

This project provides a Docker container for Kali Linux with SSH access, allowing secure remote connections for penetration testing and security research. Additionally, the container includes the ONE terminal-based AI agent installed from [noxgle/one](https://github.com/noxgle/one), providing enhanced AI-assisted interaction within the terminal environment.

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

## Configuration

ONE uses environment variables for API key configuration. Pass the API key when running the container:

```bash
# With OpenAI
docker run -d \
  --name kali-ssh-container \
  --restart unless-stopped \
  --privileged \
  -p 2222:22 \
  -e OPENAI_API_KEY=sk-your-key-here \
  ghcr.io/noxgle/kali_ai_agent_docker:main

# With Anthropic
docker run -d \
  --name kali-ssh-container \
  --restart unless-stopped \
  --privileged \
  -p 2222:22 \
  -e ANTHROPIC_API_KEY=sk-ant-your-key-here \
  ghcr.io/noxgle/kali_ai_agent_docker:main

# With Gemini
docker run -d \
  --name kali-ssh-container \
  --restart unless-stopped \
  --privileged \
  -p 2222:22 \
  -e GEMINI_API_KEY=your-gemini-key-here \
  ghcr.io/noxgle/kali_ai_agent_docker:main
```

Supported providers: **OpenAI**, **Anthropic**, **Gemini**, **Ollama** (local), **llama.cpp** (local).

For local models (Ollama/llama.cpp), set the URL via environment variable:
```bash
# Ollama
docker run -d -e OLLAMA_BASE_URL=http://host-ip:11434/v1 ...

# llama.cpp
docker run -d -e LLAMA_CPP_BASE_URL=http://host-ip:8080 ...
```

## Usage Examples

After connecting via SSH, you can use ONE in different modes:

```bash
# Interactive REPL mode
one

# TUI (Textual UI) mode
one --mode tui

# Headless one-shot task execution
one run "summarize this repository"

# Headless with JSON output
one run "fix failing tests" --json
```

For more options, run `one --help` or `one --help --mode tui`.
