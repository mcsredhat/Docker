# Dockerized Python Application

A secure, containerized Python Flask application with PostgreSQL database integration.

## Project Structure

```
project-root/
├── Dockerfile
├── docker-compose.yml
├── .env
├── app/
│   ├── main.py
│   ├── config/
│   │   ├── settings.py
│   ├── logs/
│   │   ├── app.log
│   ├── scripts/
│   │   ├── entrypoint.sh
│   │   ├── debug.sh
│   ├── requirements.txt
├── security/
│   ├── seccomp-profile.json
└── README.md
```

## Features

- Containerized Python Flask application
- PostgreSQL database integration
- Environment-based configuration
- Enhanced security with seccomp profiles
- Persistent data storage using Docker volumes
- Debugging utilities

## Prerequisites
- Docker
- Docker Compose
- Git (optional)

## Quick Start

1. Clone the repository (or create the directory structure as shown above)

2. Make sure the script files are executable:
   ```
   chmod +x app/scripts/*.sh
   ```

3. Start the application:
   ```
   docker-compose up -d
   ```

4. Access the application:
   ```
   http://localhost:5000
   ```

## Configuration

The application can be configured using environment variables defined in the `.env` file:

| Variable | Description | Default |
|----------|-------------|---------|
| APP_ENV | Application environment | production |
| DB_USER | Database username | admin |
| DB_PASS | Database password | securepassword |
| DB_HOST | Database hostname | db |
| DB_PORT | Database port | 5432 |

## Security Features

This project implements several security best practices:

- Alpine-based images for smaller attack surface
- No-new-privileges security option
- Custom seccomp profile to limit system calls
- Environment-based secrets management
- Isolated database service

## Development

### Debugging

To connect to a running container for debugging:

```
./app/scripts/debug.sh
```

### Logs

Application logs are stored in `app/logs/app.log` and are persisted through a volume mount.

### Custom Entrypoint

The application uses a custom entrypoint script that can be extended to include initialization tasks.

## Docker Compose Services

### Application Service (`app`)

- Built from local Dockerfile
- Exposes port 5000
- Uses environment variables from `.env`
- Enhanced security with seccomp profile
- Mounts logs directory for persistence

### Database Service (`db`)

- Uses PostgreSQL Alpine image
- Automatic restart
- Environment variables from Docker Compose
- Persistent data using a named volume

## Volumes

- `db_data`: Stores PostgreSQL data
- `./logs:/app/logs`: Persists application logs

## Extending the Project

### Adding New Dependencies

Add new Python packages to `app/requirements.txt` and rebuild the image:

```
docker-compose build app
```

### Modifying the Seccomp Profile

The seccomp profile in `security/seccomp-profile.json` can be extended to allow additional system calls as needed.

## Troubleshooting

- **Database connection issues**: Make sure the environment variables match between services
- **Permission denied**: Check that script files are executable
- **Container won't start**: Review Docker logs with `docker-compose logs`

