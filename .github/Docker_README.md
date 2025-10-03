# GitHub Actions Workflows

This directory contains GitHub Actions workflows for automated Docker image building, security scanning, and deployment of the Kali AI Agent Docker project.

## Workflows Overview

### 1. Docker Build Workflow (`docker-build.yml`)

**Triggers:**
- Push to `main` branch
- Pull requests to `main` branch

**Features:**
- ✅ Multi-platform builds (AMD64, ARM64)
- ✅ Automated testing of built images
- ✅ Security vulnerability scanning with Trivy
- ✅ Docker layer caching for faster builds
- ✅ Publishing to GitHub Container Registry
- ✅ Smart tagging strategy

### 2. Security Updates Workflow (`security-updates.yml`)

**Triggers:**
- Weekly scheduled scan (Sundays at 2 AM UTC)
- Manual trigger via GitHub Actions tab

**Features:**
- ✅ Comprehensive security scanning
- ✅ Base image update checks
- ✅ Vulnerability reporting in GitHub Security tab
- ✅ Docker Scout integration (on manual runs)

### 3. Release Workflow (`release.yml`)

**Triggers:**
- Push of version tags (e.g., `v1.0.0`, `v2.1.3`)

**Features:**
- ✅ Automated GitHub releases with changelog
- ✅ Docker image building and publishing
- ✅ Release notes with Docker usage instructions

## Configuration

### Required Secrets

Add the following secrets to your GitHub repository:

1. **SSH_PASSWORD** - Password for SSH access to the container
   - Go to Settings → Secrets and variables → Actions
   - Add `SSH_PASSWORD` with your desired password

### Optional Secrets

- **DOCKERHUB_USERNAME** - If you want to push to Docker Hub
- **DOCKERHUB_TOKEN** - Docker Hub access token

## Usage

### Automatic Builds

The workflows run automatically when you:

1. **Push to main branch** → Builds and tests the image
2. **Create a pull request** → Builds and tests without publishing
3. **Push a version tag** → Creates a release and publishes tagged image

### Manual Operations

1. **Trigger security scan manually:**
   - Go to Actions tab in GitHub
   - Select "Security Updates and Dependency Check"
   - Click "Run workflow"

2. **Create a release:**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

## Workflow Details

### Docker Build Process

1. **Checkout** repository code
2. **Set up Docker Buildx** for multi-platform builds
3. **Extract metadata** for tagging
4. **Build and test** the image locally
5. **Run security scan** with Trivy
6. **Upload results** to GitHub Security tab
7. **Deploy** (if not a PR) to registry

### Security Scanning

The security workflow performs:

- **Vulnerability scanning** of the Docker image
- **Base image comparison** to detect updates
- **SARIF report generation** for GitHub Security tab
- **Summary reporting** in workflow run

### Release Process

1. **Generate changelog** from git commits
2. **Create GitHub release** with Docker instructions
3. **Build multi-platform image**
4. **Push to registry** with version and latest tags

## Tagging Strategy

The workflows use the following tagging strategy:

- `latest` - Latest from main branch
- `v1.0.0` - Specific version tags
- `main` - Branch name (development builds)
- `sha-abc123` - Short commit SHA for tracking

## Image Registry

Images are published to **GitHub Container Registry (ghcr.io)**:

```
ghcr.io/your-username/kali_ai_agent_docker:latest
ghcr.io/your-username/kali_ai_agent_docker:v1.0.0
```

## Troubleshooting

### Build Failures

1. **Check Docker Buildx setup**
   ```bash
   docker buildx ls
   docker buildx inspect default
   ```

2. **Verify Dockerfile syntax**
   ```bash
   docker build --dry-run .
   ```

3. **Check available disk space**
   ```bash
   df -h
   ```

### Security Scan Issues

1. **Trivy not found** - Usually resolves with retry
2. **SARIF upload fails** - Check permissions in workflow

### Publishing Issues

1. **Authentication fails** - Verify GITHUB_TOKEN permissions
2. **Registry access denied** - Check package permissions in repository settings

## Performance Optimization

### Build Caching

The workflows use GitHub Actions cache backend for faster builds:

- **Cache layers** between builds
- **Multi-platform builds** in parallel
- **Conditional steps** to skip unnecessary work

### Security Scanning

- **Incremental scanning** for faster results
- **Severity filtering** (CRITICAL, HIGH, MEDIUM)
- **Parallel scanning** where possible

## Customization

### Adding New Tests

Edit the test section in `docker-build.yml`:

```yaml
- name: Test Docker image
  run: |
    docker run --rm kali-ai-agent:test /bin/bash -c "
      # Add your custom tests here
      echo 'Testing custom functionality...'
    "
```

### Additional Security Tools

Add more security scanning tools:

```yaml
- name: Run custom security scan
  uses: your-security-tool/action@v1
  with:
    image-ref: kali-ai-agent:test
```

### Custom Registry

To publish to Docker Hub instead:

```yaml
env:
  REGISTRY: docker.io
  IMAGE_NAME: your-username/your-repo
```

## Support

For issues with the GitHub Actions workflows:

1. Check the Actions tab for workflow runs
2. Review logs for error messages
3. Ensure all required secrets are configured
4. Verify repository permissions for package publishing

## Contributing

When modifying workflows:

1. Test changes in a feature branch
2. Verify all workflow triggers work correctly
3. Update this documentation if needed
4. Consider backward compatibility
