# Secure Web Server

A lightweight, secure, and optimized web server built with Python and Docker.

## Project Structure

```
/secure-web-server
├── Dockerfile
├── .env
├── requirements.txt
├── app.py
└── README.md
```

## Features

### Security
- Non-root user execution
- Minimal base image (Python 3.9-slim)
- Regular security updates via apt-get
- Resource constraints for container isolation
- Environment variable configuration
- Health checks

### Optimization
- Layer caching with separate requirements installation
- Threaded server for improved performance
- Configurable maximum connections
- Port reuse enabled

## Prerequisites

- Docker
- Docker Compose (optional)

## Setup and Installation

### Building the Docker Image

```
docker build -t secure-python-web:latest .
```

### Running the Container

```
docker run -d \
  --name py-web \
  --memory=128m \
  --cpus=0.25 \
  -p 8000:8000 \
  --env-file .env \
  secure-python-web:latest
```

## Configuration

### Environment Variables (.env)

| Variable | Description | Default |
|----------|-------------|---------|
| PORT | Server port | 8000 |
| DEBUG | Enable debug mode | false |
| MAX_CONNECTIONS | Maximum concurrent connections | 100 |

## Monitoring

### Container Status
# Check running containers
```
docker ps
```
# View resource usage
```
docker stats py-web
```

### Testing the Server
# Basic connectivity test
```
curl http://localhost:8000
```
# Inspect container configuration
```
docker inspect py-web | grep -i "memory\|cpu"
```

## Load Testing
# Install Apache Bench if needed
```
sudo apt install apache2-utils
```

# Run load test
```
ab -n 1000 -c 10 http://localhost:8000/
```

