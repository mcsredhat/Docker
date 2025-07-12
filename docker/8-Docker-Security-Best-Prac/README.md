# Secure Docker Container Project

## Overview

This project demonstrates comprehensive Docker security best practices and container management techniques. It provides a production-ready setup with built-in security measures, monitoring capabilities, and automated deployment strategies for containerized Node.js applications.

## 🔒 Security Features

- **Non-root user execution** with proper permission management
- **Vulnerability scanning** integration for container images
- **Resource limitations** and security constraints
- **Health checks** and monitoring capabilities
- **Secure networking** configurations
- **Multi-stage builds** for optimized image size
- **AppArmor and Seccomp** profile support

## 📁 Project Structure

```
secure-docker-project/
├── app/
│   ├── server.js           # Node.js application server
│   ├── package.json        # Node.js dependencies
│   └── package-lock.json   # Dependency lock file
├── docker-compose.yml      # Docker Compose configuration
├── Dockerfile              # Container build instructions
├── .dockerignore          # Files to exclude from build context
├── .env                   # Environment variables
└── README.md              # This documentation
```

## 🚀 Quick Start

### Prerequisites

- Docker Engine (version 20.10 or later)
- Docker Compose (version 2.0 or later)
- Node.js (for local development)
- curl (for testing endpoints)

### Environment Setup

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd secure-docker-project
   ```

2. **Create environment file:**
   ```bash
   cp .env.example .env
   # Edit .env file with your configuration
   ```

3. **Build and run with Docker Compose:**
   ```bash
   docker-compose up --build -d
   ```

### Manual Docker Commands

**Build the image:**
```bash
docker build -t secure-node-app:latest .
```

**Run the container:**
```bash
docker run -d \
  --name secure-node-app \
  -p 3000:3000 \
  --user 1010:1010 \
  --security-opt no-new-privileges \
  --cap-drop ALL \
  secure-node-app:latest
```

## 🛡️ Security Implementation

### 1. Non-Root User Execution

The application runs as a dedicated non-root user (`nodeuser`) with specific UID/GID:

```dockerfile
# Create non-root user
RUN groupadd -g 1010 nodegroup && \
    useradd -u 1010 -g nodegroup -m nodeuser

# Switch to non-root user
USER nodeuser
```

**Verification:**
```bash
docker exec secure-node-app id
# Expected output: uid=1010(nodeuser) gid=1010(nodegroup)
```

### 2. Vulnerability Scanning

**Scan images before deployment:**
```bash
# Using Docker's built-in scanner
docker scan secure-node-app:latest

# Using Trivy (recommended)
trivy image secure-node-app:latest

# Using Grype
grype secure-node-app:latest
```

**CI/CD Integration:**
```yaml
# GitHub Actions example
- name: Scan image
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: 'secure-node-app:latest'
    format: 'sarif'
    output: 'trivy-results.sarif'
```

### 3. Resource Limitations

Docker Compose automatically applies resource constraints:

```yaml
deploy:
  resources:
    limits:
      memory: 256M
      cpus: "0.5"
    reservations:
      memory: 128M
      cpus: "0.25"
```

### 4. Security Options

```yaml
security_opt:
  - no-new-privileges:true
```

## 🔧 Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `NODE_ENV` | `production` | Node.js environment |
| `PORT` | `3000` | Application port |
| `APP_HOST` | `localhost` | Application host |

### Docker Compose Override

Create `docker-compose.override.yml` for local development:

```yaml
version: "3.8"
services:
  node-app:
    environment:
      - NODE_ENV=development
    volumes:
      - ./app:/app
    command: ["npm", "run", "dev"]
```

## 📊 Monitoring & Health Checks

### Health Check Endpoint

The application includes a built-in health check endpoint:

```bash
curl http://localhost:3000/health
```

### Container Health Monitoring

```bash
# Check container health status
docker inspect --format "{{.State.Health.Status}}" secure-node-app

# View health check logs
docker inspect --format "{{range .State.Health.Log}}{{.Output}}{{end}}" secure-node-app
```

### Resource Monitoring

```bash
# Monitor resource usage
docker stats secure-node-app

# Detailed container information
docker inspect secure-node-app | jq '.State.Health'
```

## 🔍 Troubleshooting

### Common Issues

**1. Permission Denied Errors**
```bash
# Check file permissions
docker exec secure-node-app ls -la /app

# Verify user context
docker exec secure-node-app whoami
```

**2. Health Check Failures**
```bash
# Check health check logs
docker logs secure-node-app --tail 20

# Manual health check
docker exec secure-node-app curl -f http://localhost:3000/health
```

**3. Container Won't Start**
```bash
# Check container logs
docker logs secure-node-app

# Inspect container configuration
docker inspect secure-node-app
```

### Debug Mode

Run container in debug mode:
```bash
docker run -it --rm \
  --user 1010:1010 \
  secure-node-app:latest \
  /bin/bash
```

## 🧪 Testing

### Security Testing

**1. Verify Non-Root Execution:**
```bash
docker exec secure-node-app id
# Should not show uid=0 (root)
```

**2. Test Capability Restrictions:**
```bash
docker exec secure-node-app capsh --print
# Should show limited capabilities
```

**3. Verify Network Security:**
```bash
# Test application endpoint
curl -i http://localhost:3000/

# Test health endpoint
curl -i http://localhost:3000/health
```

### Performance Testing

```bash
# Load testing with Apache Bench
ab -n 1000 -c 10 http://localhost:3000/

# Memory usage monitoring
docker stats secure-node-app --no-stream
```

## 🚀 Advanced Security Configurations

### Custom AppArmor Profile

Create custom AppArmor profile for enhanced security:

```bash
# Create profile
sudo nano /etc/apparmor.d/docker-secure-node

# Load profile
sudo apparmor_parser -r -W /etc/apparmor.d/docker-secure-node

# Run with custom profile
docker run --security-opt apparmor=docker-secure-node secure-node-app:latest
```

### Custom Seccomp Profile

Apply custom seccomp profile to restrict system calls:

```bash
docker run --security-opt seccomp=./seccomp-profile.json secure-node-app:latest
```

### Network Security

Create isolated networks:

```bash
# Create application network
docker network create app-network --driver bridge

# Run container on custom network
docker run -d --network app-network --name secure-node-app secure-node-app:latest
```


## 🧹 Cleanup

### Remove Containers and Images

```bash
# Stop and remove container
docker-compose down

# Remove images
docker rmi secure-node-app:latest

# Clean up unused resources
docker system prune -a
```

### Complete Cleanup

```bash
# Remove all project-related containers, images, and volumes
docker-compose down -v --rmi all
docker system prune -a
```

