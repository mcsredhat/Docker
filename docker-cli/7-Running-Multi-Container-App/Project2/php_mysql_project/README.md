# PHP, MySQL, and Adminer Web Stack

This project demonstrates how to deploy a three-container setup with a PHP web application, MySQL database, and Adminer for database management using Docker.

## Overview

This setup creates a complete web stack with:
- Frontend (PHP Apache server)
- Backend database (MySQL)
- Administration tool (Adminer)
- All communicating on a custom Docker network
- All externally accessible via port mapping

## Directory Structure

```
php_mysql_project/
│── Dockerfile
│── .env
│── docker-compose.yml
│── index.php
```

## Components

### PHP Application

The PHP application is a simple message board that:
- Connects to the MySQL database
- Creates a messages table if it doesn't exist
- Allows users to post new messages
- Displays all posted messages in reverse chronological order

### MySQL Database

The MySQL database stores all the message data with:
- Persistent storage using Docker volumes
- Proper user authentication
- Custom database configuration

### Adminer

Adminer provides a web-based interface for:
- Database management
- Running SQL queries
- Managing tables and records
- Importing and exporting data

## Environment Configuration

The application uses environment variables defined in the `.env` file:

- `MYSQL_ROOT_PASSWORD`: Root password for MySQL
- `MYSQL_DATABASE`: Name of the application database
- `MYSQL_USER`: Username for application database access
- `MYSQL_PASSWORD`: Password for application database access

## Setup and Installation

### Prerequisites

- Docker and Docker Compose installed on your system

### Deployment Steps

1. **Start the Application Stack**

   ```
   docker compose up -d
   ```

   This command builds the PHP application image and starts all three containers in detached mode.

2. **Access the Applications**

   - **PHP App:** [http://localhost:8080](http://localhost:8080)
   - **Adminer:** [http://localhost:8081](http://localhost:8081)

   For Adminer, use these login credentials:
   - System: MySQL
   - Server: mysql-db
   - Username: webuser
   - Password: webpass
   - Database: webappdb

## Architecture

The project consists of three services:

1. **MySQL Database (mysql-db)**
   - Uses the official MySQL 8 image
   - Stores data in a persistent volume
   - Not directly accessible from outside the Docker network

2. **PHP Application (php-app)**
   - Built from a custom Dockerfile using PHP 8.1 with Apache
   - Connects to MySQL using provided credentials
   - Exposes port 80 to port 8080 on the host
   - Depends on the MySQL service

3. **Adminer (adminer)**
   - Uses the official Adminer image
   - Provides database administration through a web interface
   - Exposes port 8080 to port 8081 on the host
   - Depends on the MySQL service

## Data Persistence

The MySQL service uses a Docker volume named `mysql-data` to persist database contents. This ensures that message data survives container restarts or rebuilds.

## Network Configuration

All three services are connected via an internal Docker network named `web-app-net`. This allows:
- The PHP application to communicate with MySQL
- Adminer to communicate with MySQL
- Isolation from other Docker networks
- Security by limiting external access to the database

## Maintenance

### Viewing Logs

# View PHP app logs
```
docker logs php-app
```
# View MySQL logs
```
docker logs mysql-db
```
# View Adminer logs
```
docker logs adminer
```

### Accessing MySQL CLI
```
docker exec -it mysql-db mysql -uwebuser -pwebpass webappdb
```

### Backing Up the Database
```
docker exec mysql-db sh -c 'exec mysqldump -uwebuser -pwebpass webappdb' > backup.sql
```

## Scaling and Production Considerations
For production environments, consider:

1. Implementing proper HTTPS with SSL/TLS certificates
2. Setting up a reverse proxy (like Nginx) for the web services
3. Implementing proper database backup strategies
4. Setting up proper logging and monitoring
5. Using environment-specific configuration files
6. Implementing proper security measures (firewall, access control, etc.)

## Troubleshooting

- **PHP cannot connect to MySQL**: Ensure the MySQL container is running and check network configuration.
- **Database not initializing**: Check MySQL logs for any error messages.
- **Permission issues**: You may need to adjust permissions for the MySQL data directory.

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

