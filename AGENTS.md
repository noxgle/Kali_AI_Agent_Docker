# Kali AI Agent Docker — Agent Notes

## Project shape
- **Docker-only project.** No tests, lint, formatter, or package manager. The executable artifacts are `Dockerfile`, `docker-compose.yml`, and `entrypoint.sh`.
- Base image: `kalilinux/kali-rolling`.
- Target platform: `linux/amd64` only (hardcoded in CI).
- The image includes the **ONE terminal AI agent**.

## Key files
| File | Role |
|---|---|
| `Dockerfile` | Installs SSH and Kali packages, clones `noxgle/one`, and creates its virtual environment. |
| `docker-compose.yml` | Builds the image, maps `2222:22`, and runs the container as privileged. |
| `entrypoint.sh` | Adds `/one/.venv/bin` to `PATH`, displays ONE and SSH instructions, then starts `sshd -D`. |
| `.github/workflows/docker-build.yml` | Builds, smoke-tests, and deploys the image to GHCR. |
| `.github/workflows/release.yml` | On version tag push, creates a GitHub release and pushes tagged images. |

## Developer commands
```bash
# Build
docker-compose build

# Run
docker-compose up -d

# SSH into container
ssh root@localhost -p 2222
# Password: 123456

# Direct pull (no clone needed)
docker pull ghcr.io/noxgle/kali_ai_agent_docker:main
docker run -d --name kali-ssh-container --restart unless-stopped --privileged -p 2222:22 ghcr.io/noxgle/kali_ai_agent_docker:main
```

## ONE dependency
- Cloned at **build time** from `https://github.com/noxgle/one.git` (Dockerfile line 36). No branch or tag is pinned, so the default branch is used.
- Installed in `/one/` with a local virtual environment at `/one/.venv`.
- `entrypoint.sh` prepends `/one/.venv/bin` to `PATH`; the CLI is available as `one`.
- Common commands advertised by the image:
  - `one` — start the terminal agent.
  - `one run "task"` — run a task headlessly.
  - `one --mode tui` — start the Textual UI.
  - `one --mode text` — start REPL mode.
- API credentials are supplied at runtime through environment variables: `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, or `GEMINI_API_KEY`. `OLLAMA_BASE_URL` may be set for local Ollama.

## SSH credentials
- The default root password is hardcoded as `123456` in the Dockerfile (`RUN echo "root:123456" | chpasswd`).
- `release.yml` supplies an `SSH_PASSWORD` build arg, but the Dockerfile does not declare or consume this argument. It is ignored and does not change the password.

## CI / CD
- **Triggers:** push to `main`, version-tag pushes matching `v*.*.*`, PRs to `main`, weekly schedule (Monday 02:00 UTC), and `workflow_dispatch`.
- **Build:** `docker/build-push-action@v5`, `no-cache: true`, GHA layer-cache configuration, AMD64 only.
- **Test:** separately builds the image with `docker build --no-cache`, starts a container, then stops and removes it. There are no SSH or command-level tests.
- **Deploy:** pushes to `ghcr.io/<repository>` with `latest` on the default branch, branch, PR, semver, and branch-prefixed SHA tags as produced by `docker/metadata-action`.
- **Release:** a `v*.*.*` tag push creates a GitHub release and separately pushes `:latest` and `:<tag>` images.

## Gotchas
- `privileged: true` in docker-compose is required for Kali tooling but increases the attack surface.
- `no-cache: true` in CI makes the configured GHA layer cache effectively unused.
- `.github/Docker_README.md` is outdated: it references a missing `security-updates.yml` workflow, Trivy scans, and `SSH_PASSWORD` configuration. Do not follow it.
- `release.yml` release notes also incorrectly mention `SSH_PASSWORD` and the obsolete `ag`/`ask`/`prom` commands.
- `Dockerfile.bak` is in `.dockerignore`; ignore it.
