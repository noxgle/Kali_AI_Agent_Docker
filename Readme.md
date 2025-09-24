# Kali AI Agent Docker Container

This project provides a Docker container for Kali Linux with SSH access, allowing secure remote connections for penetration testing and security research. Additionally, the container includes a terminal-based AI agent and chat tool installed from [noxgle/term_agent](https://github.com/noxgle/term_agent.git), providing enhanced AI-assisted interaction within the terminal environment.

This project uses `docker-compose` to build and run the Docker image. SSH credentials (username and password) are securely managed through a `.env` file.

**Before building, create a `.env` file in the project root with the following content:**
```
SSH_PASSWORD=your_password
```
Replace `your_password` with your desired SSH credentials for root.


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
Password: `${SSH_PASSWORD:-your_ssh_password_from_env}`

## Post-Installation Configuration

Immediately after the first SSH login (or by using `docker exec -it <container_name> bash`), you need to configure the terminal AI agent. Edit the configuration file located at `/term_agent/.env` and specify the API details with your own API key. The terminal AI agent supports Google GenAI, ChatGPT (OpenAI), and Ollama APIs - select and configure the API you prefer for authentication.
