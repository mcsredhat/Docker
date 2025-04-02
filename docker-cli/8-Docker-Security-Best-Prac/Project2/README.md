# Secure Node.js Application

This project demonstrates how to create a security-hardened Node.js application using Docker with best practices for container security.

## Overview

The project implements a containerized Node.js web server with multiple security enhancements:

- Multi-stage build to reduce image size
- Running as a non-root user
- Dropping unnecessary capabilities
- Using slim base images
- Regular security updates
- Proper permission management

## Directory Structure

```
secure-node/
│── Dockerfile
│── app.js
│── package.json
```

## Prerequisites

Before getting started, ensure you have the following:

- Docker Engine (version 20.10.0 or higher)
- Docker Scan (or another container scanning tool) for vulnerability scanning
- Node.js (for local development)

## Security Features

This implementation includes several key security features:

1. **Multi-stage Build**
   - Separates build dependencies from runtime
   - Results in a smaller final image with fewer vulnerabilities

2. **Non-Root User Execution**
   - Creates a dedicated user and group (nodeuser:nodegroup)
   - Application runs with reduced privileges

3. **Minimal Base Image**
   - Uses Node.js slim variant to reduce attack surface
   - Regular updates to patch vulnerabilities

4. **Limited Container Capabilities**
   - Drops all Linux capabilities by default
   - Only essential capabilities are retained

5. **Security Options**
   - Prevents privilege escalation with no-new-privileges flag

6. **Proper File Permissions**
   - All files have appropriate ownership and permissions

## Setup and Installation

1. **Create the project structure**

   Create the directories and files as shown in the directory structure.

2. **Build the Docker image**

   ```
   docker build -t secure-node:latest .
   ```

3. **Scan for vulnerabilities**

   ```
   docker scan secure-node:latest
   ```

4. **Run the container with security options**

   ```
   docker run -d \
     --name secure-node-app \
     -p 3000:3000 \
     --security-opt no-new-privileges \
     --cap-drop ALL \
     secure-node:latest
   ```

## Verification

After deployment, verify the security configuration:

1. **Check user permissions**

   ```
   docker exec secure-node-app id
   ```
   
   Expected output: `uid=1001(nodeuser) gid=1001(nodegroup)`

2. **Test access**

   ```
   curl http://localhost:3000
   ```
   
   Expected output: "Secure Node.js Application Running!"

## Security Best Practices

### Container Security

1. **Keep Dependencies Updated**
   - Regularly update your Node.js version and dependencies
   - Run `npm audit` to check for vulnerabilities

2. **Use Environment Variables for Secrets**
   - Never hardcode sensitive information
   - Pass secrets via environment variables

3. **Implement Content Security Policy**
   - For web applications, add appropriate headers
   - Limit allowed sources for scripts and other resources

4. **Set Resource Limits**
   ```
   docker run --memory=256m --cpus=0.5 [...]
   ```

### Node.js Security

1. **Input Validation**
   - Validate all input from users
   - Use middleware like Helmet.js for additional security

2. **Dependency Management**
   - Use `npm ci` instead of `npm install` in production builds
   - Consider using npm shrinkwrap or package-lock.json

3. **Security Monitoring**
   - Implement logging for security events
   - Consider using tools like Snyk or OWASP Dependency-Check

## Troubleshooting

### Container fails to start

Check logs for permission issues:
```
docker logs secure-node-app
```

### Node.js cannot access files

Ensure proper permissions for application files:
```
docker exec secure-node-app ls -la /app
```

### Application crashes

Check for runtime errors:
```
docker logs secure-node-app
```

## Production Recommendations

For production environments, consider these additional security measures:

1. **Implement health checks**
   ```
   docker run --health-cmd="curl -f http://localhost:3000 || exit 1" [...]
   ```

2. **Use a read-only filesystem**
   ```
   docker run --read-only [...]
   ```

3. **Set up proper logging**
   - Configure structured logging
   - Forward logs to a centralized logging system

4. **Implement rate limiting**
   - Protect against DoS attacks
   - Use middleware like express-rate-limit

