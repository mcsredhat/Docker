# Node.js and MongoDB Application

This project demonstrates how to deploy a full-stack application with a Node.js frontend and MongoDB database using Docker containers.
## Overview
The application is a simple web server that tracks page visits by storing them in a MongoDB database. Each time the homepage is accessed, a new visit record is created and the total number of visits is displayed to the user.

## Directory Structure

```
nodejs_mongo_project/
│── Dockerfile
│── .env
│── docker-compose.yml
│── package.json
│── app.js
```

## Features
- **Node.js Express Server**: Handles HTTP requests and interacts with the database
- **MongoDB Database**: Stores visit records with timestamps
- **Docker Containerization**: Isolates services and simplifies deployment
- **Persistent Storage**: MongoDB data survives container restarts
- **Network Communication**: Services communicate via an internal Docker network

## Environment Configuration

The application uses environment variables defined in the `.env` file for configuration:

- `MONGO_INITDB_ROOT_USERNAME`: MongoDB admin username
- `MONGO_INITDB_ROOT_PASSWORD`: MongoDB admin password
- `PORT`: The port on which the Node.js application will run

## Setup and Installation

### Prerequisites

- Docker and Docker Compose installed on your system

### Deployment Steps

1. **Start the Application**

   ```
   docker compose up -d
   ```

   This command builds the Node.js application image and starts both the Node.js and MongoDB containers in detached mode.

2. **Access the Application**

   Open  in your browser.
    ```
   http://localhost:3000
   curl http://localhost:3000
   ```
   You should see a page displaying the message: "Hello! This page has been visited X times."

## Architecture

The project consists of two services:

1. **MongoDB (mongodb)**
   - Uses the official MongoDB image
   - Stores data in a persistent volume
   - Runs with authentication enabled
   - Not directly accessible from outside the Docker network

2. **Node.js Application (node-app)**
   - Built from a custom Dockerfile using Node.js 18
   - Connects to MongoDB using provided credentials
   - Exposes port 3000 to the host
   - Depends on the MongoDB service

## Data Persistence

The MongoDB service uses a Docker volume named `mongodb-data` to persist database contents. This ensures that visit counts and other data survive container restarts or rebuilds.

## Network Configuration

Both services are connected via an internal Docker network named `app-network`. This allows:
- The Node.js application to communicate with MongoDB
- Isolation from other Docker networks
- Security by limiting external access to the database

## Maintenance

### Viewing Logs

# View Node.js app logs
```
docker logs node-app
```

# View MongoDB logs
```
docker logs mongodb
```

### Accessing MongoDB Shell
```
docker exec -it mongodb mongosh -u admin -p password --authenticationDatabase admin
```

### Restarting Services
```
docker compose restart
```

## Scaling and Production Considerations

For production environments, consider:

1. Using Docker Swarm or Kubernetes for orchestration
2. Implementing proper MongoDB authentication and user management
3. Adding health checks to the services
4. Setting up proper logging and monitoring
5. Using environment-specific configuration files

## Cleanup

To stop the services and remove the containers:
```
docker compose down
```

To completely remove all data (including volumes):
```
docker compose down -v
```

**Warning**: Using the `-v` flag will delete all persistent data. Only use this when you want to completely start over.

## Troubleshooting

- **Connection refused errors**: Ensure both containers are running and on the same network
- **Authentication errors**: Verify MongoDB credentials in the .env file
- **Container startup issues**: Check logs for error messages

