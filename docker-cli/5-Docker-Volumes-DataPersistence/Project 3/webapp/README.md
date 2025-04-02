# Web Application with User Uploads

## Project Overview
This project demonstrates deploying a web application with persistent storage for user uploads using Docker containers and volumes. The setup ensures that user-uploaded files remain intact during container upgrades or restarts.

## Features
- Containerized web application (Nginx)
- Persistent storage for user uploads
- Volume mounting for data preservation
- Simplified upgrade process
- Accessible through a web browser

## Prerequisites
- Docker Engine (version 19.03 or newer)
- Docker Compose (version 1.27 or newer)
- Basic understanding of web servers and Docker concepts

## Project Structure
```
webapp/
├── Dockerfile          # Container configuration for the web application
├── docker-compose.yml  # Docker Compose configuration
└── README.md           # This documentation
```

## Quick Start
### 1. Deploy the Web Application
```
docker compose up -d
```

### 2. Access the Application
Open your web browser and navigate to:
```
http://localhost:8080
```

## Storage Configuration
The application uses a Docker volume (`webapp-uploads`) mounted to `/app/uploads` within the container. This ensures that:
- All files uploaded by users are stored persistently
- Data survives container restarts and removals
- Files remain intact during application upgrades

## Upgrading the Application
To upgrade the web application without losing user data:

# Stop the current container
```
docker compose down
```
# Pull the latest image
```
docker pull nginx:latest
```
# Restart with the new image
```
docker compose up -d
```

The user uploads will remain intact throughout this process due to the persistent volume configuration.

## Testing File Persistence
You can test the persistence by:
1. Creating a test file in the uploads directory:
```
docker exec -it my-webapp touch /app/uploads/test-file.txt
```

2. Verifying the file exists after container restart:
```
docker compose down
```
```
docker compose up -d
```
```
docker exec -it my-webapp ls -la /app/uploads
```

## Managing Uploads
To manage the user uploads, you can:

### List Files
```
docker exec -it my-webapp ls -la /app/uploads
```

### Copy Files to Host
```
docker cp my-webapp:/app/uploads/filename.ext ./local-copy.ext
```

### Copy Files to Container
```
docker cp ./local-file.ext my-webapp:/app/uploads/
```

## Volume Management
- List volumes: `docker volume ls`
- Inspect volume: `docker volume inspect webapp-uploads`
- Backup volume: `docker run --rm -v webapp-uploads:/source -v $(pwd):/backup alpine tar -czvf /backup/webapp-uploads.tar.gz -C /source .`
- Restore volume: `docker run --rm -v webapp-uploads:/target -v $(pwd):/backup alpine sh -c "tar -xzvf /backup/webapp-uploads.tar.gz -C /target"`

## Troubleshooting
- **Permission issues**: Check if the container has proper permissions to write to the volume
- **Storage problems**: Verify there's enough disk space for uploads
- **Missing files**: Confirm that files are being saved to the correct location in the volume

## Security Considerations
- Set appropriate file permissions for uploaded content
- Consider implementing file type validation and size limits
- Regularly backup your upload volume
- Scan uploaded files for malware



