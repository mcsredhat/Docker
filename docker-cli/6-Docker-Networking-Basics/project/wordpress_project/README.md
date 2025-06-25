# WordPress with Persistent Content and Networking

This project demonstrates how to deploy WordPress with a MySQL database, ensuring both the database and content are persistent across container restarts or upgrades.

## Overview

The setup uses Docker and Docker Compose to create containerized WordPress and MySQL services. Data persistence is achieved through Docker volumes for both the database and WordPress content, ensuring your site survives container restarts.

## Directory Structure

```
wordpress_project/
│── docker-compose.yml
│── .env
```

## Files
### .env File

This file contains environment variables for the MySQL database:

```
MYSQL_ROOT_PASSWORD=password
MYSQL_DATABASE=wordpress
```

## Setup Instructions

1. **Start WordPress and MySQL**

   ```
   docker compose up -d
   ```
   This command starts both the WordPress and MySQL containers in detached mode.

2. **Access WordPress**

   Open [http://localhost:8080]
   ```
   http://localhost:8080
   ```
   (http://localhost:8080) in your browser and complete the WordPress setup.

   Initial setup will require:
   - Site title
   - Username
   - Password
   - Email address

## Architecture

The project consists of two main components:

1. **MySQL Database**
   - Stores all WordPress data
   - Uses persistent volume for database files
   - Not directly accessible from outside the Docker network

2. **WordPress Application**
   - Serves the WordPress site
   - Connected to the MySQL database
   - Uses persistent volume for wp-content directory (themes, plugins, uploads)
   - Accessible via port 8080 on the host machine

## Data Persistence

This setup includes two persistent volumes:

1. **wordpress-db** - Stores the MySQL database
2. **wordpress-content** - Stores WordPress themes, plugins, and uploads

These volumes ensure your data remains intact even if:
- Containers are restarted
- Container images are updated
- You rebuild your deployment

## Network Configuration

Services are connected via an internal Docker network named `app-network`. This allows:
- WordPress to communicate with MySQL
- Isolation from other Docker networks
- Security by limiting external access to the database

## Maintenance

### Backing Up WordPress

To back up your WordPress content:

```
docker cp wordpress:/var/www/html/wp-content ./backup/
```

### Backing Up Database

To back up your MySQL database:

```
docker exec wordpress-db sh -c 'exec mysqldump -uroot -p"$MYSQL_ROOT_PASSWORD" wordpress' > backup.sql
```

### Upgrading WordPress

```
docker compose down
```

```
docker pull wordpress:latest
```

```
docker compose up -d
```

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

- **WordPress cannot connect to database**: Ensure the MySQL container is running and check network configuration.
- **Permission issues**: You may need to adjust permissions in the WordPress container.
- **Port conflicts**: If port 8080 is already in use, modify the port mapping in docker-compose.yml.

