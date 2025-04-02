# Secure Nginx Web Server

This project demonstrates how to set up a security-hardened Nginx web server using Docker with best practices for container security.

## Overview

The project implements a containerized Nginx web server with multiple security enhancements:

- Running as a non-root user
- Dropping unnecessary capabilities
- Using Alpine as a minimal base image
- Adding security headers
- Running on non-privileged ports
- Using security options to prevent privilege escalation

## Directory Structure

```
secure-nginx/
│── Dockerfile
│── nginx.conf
│── html/
│   └── index.html
```

## Prerequisites

Before getting started, ensure you have the following:

- Docker Engine (version 20.10.0 or higher)
- Docker Scan (or another container scanning tool) for vulnerability scanning

## Security Features

This implementation includes several key security features:

1. **Non-Root User Execution**
   - Creates a dedicated user and group (nginxuser:nginxgroup)
   - Nginx runs with reduced privileges

2. **Minimal Base Image**
   - Uses Alpine Linux to reduce attack surface
   - Regular updates to patch vulnerabilities

3. **Security Headers**
   - X-Content-Type-Options
   - X-Frame-Options
   - X-XSS-Protection

4. **Limited Container Capabilities**
   - Drops all Linux capabilities by default
   - Only adds back the specific capability needed (NET_BIND_SERVICE)

5. **Non-Privileged Port**
   - Uses port 8080 instead of privileged port 80

6. **Proper File Permissions**
   - All files have appropriate ownership and permissions

## Setup and Installation

1. **Create the project structure**

   Create the directories and files as shown in the directory structure.

2. **Build the Docker image**

   ```
   docker build -t secure-nginx:latest .
   ```

3. **Scan for vulnerabilities**

   ```
   docker scan secure-nginx:latest
   ```

4. **Run the container with security options**

   ```
   docker run -d \
     --name secure-web \
     -p 8080:8080 \
     --security-opt no-new-privileges \
     --cap-drop ALL \
     --cap-add NET_BIND_SERVICE \
     secure-nginx:latest
   ```

## Verification

After deployment, verify the security configuration:

1. **Check user permissions**

   ```
   docker exec secure-web id
   ```
   
   Expected output: `uid=1001(nginxuser) gid=1001(nginxgroup)`

2. **Check capabilities**

   ```
   docker exec secure-web capsh --print
   ```
   
   Expected output should show limited capabilities with only NET_BIND_SERVICE added.

3. **Test access**

   ```
   curl http://localhost:8080
   ```
   
   You should see the HTML response from your index page.

## Security Recommendations

For production environments, consider these additional security measures:

1. **Use Docker Content Trust**
   ```
   export DOCKER_CONTENT_TRUST=1
   ```

2. **Implement a read-only filesystem**
   ```
   docker run --read-only [...]
   ```

3. **Set memory and CPU limits**
   ```
   docker run --memory=128m --cpus=0.5 [...]
   ```

4. **Use security profiles**
   - Implement AppArmor or SELinux profiles
   - Consider using seccomp profiles

5. **Regular scanning and updates**
   - Scan images regularly for vulnerabilities
   - Update base images and dependencies

## Troubleshooting

### Container fails to start

Check logs for permission issues:
```
docker logs secure-web
```

### Nginx cannot write to necessary directories

Ensure proper permissions for runtime directories:
```
docker exec secure-web ls -la /var/cache/nginx
```

```
docker exec secure-web ls -la /var/run/nginx.pid
```

### Security scan shows vulnerabilities

Update base images and packages:
```
docker build --no-cache -t secure-nginx:latest .
```

