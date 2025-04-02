# Flask-Redis Multi-Container Demo
## Overview
This project demonstrates a multi-container development environment using Docker, featuring a Flask web application that connects to Redis for visit counting. It showcases container linking, state persistence, and basic Docker networking concepts.

## Project Structure
```
flask-demo/
├── app/
│   ├── app.py            # Flask application with Redis integration
│   └── requirements.txt  # Python dependencies
├── Dockerfile            # Container configuration for Flask app
└── README.md             # This documentation
```

## Features
- Multi-container architecture with application and database containers
- State persistence across container restarts
- Container linking for networking
- Visit counter functionality with Redis
- Interactive and detached container running modes

# Prerequisites
- Docker Engine (version 19.03 or newer)
- Basic understanding of Python and Flask
- Familiarity with Redis concepts
- curl or a web browser for testing

## Getting Started
## Building the Application Image
```
docker build -t flask-redis-app:latest .
```

### Running the Application
#### 1. Start the Redis Container
```
docker run -d --name redis redis:alpine
```

#### 2. Start the Flask Application
```
docker run -it --name flask-app -p 5000:5000 --link redis flask-redis-app:latest
```

### Testing the Application
Open your browser and navigate to http://localhost:5000 or use curl:
```
curl http://localhost:5000
```
Each visit will increment the counter stored in Redis.

## Container Management
### Stopping Containers
```
docker stop flask-app redis
```

### Restarting Containers
```
docker restart redis
```

```
docker restart flask-app
```

The visit counter will maintain its value across container restarts, demonstrating state persistence in Redis.

### Cleaning Up
```
docker stop flask-app redis
```

```
docker rm flask-app redis
```

## Key Concepts Demonstrated
- **Multi-Container Architecture**: Separating application and data layers
- **Container Linking**: Communication between isolated containers
- **State Persistence**: Data retention across container restarts
- **Interactive vs. Detached Mode**: Different ways to run containers
- **Port Mapping**: Exposing container services to the host

