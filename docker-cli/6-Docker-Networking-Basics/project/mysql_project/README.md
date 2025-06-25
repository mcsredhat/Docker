# MySQL Database with Persistent Storage

This project demonstrates deploying a MySQL database in a Docker container with persistent storage, ensuring data survives container restarts.

## Overview

The setup uses Docker and Docker Compose to create a containerized MySQL database. Data persistence is achieved through Docker volumes, which store the database files on the host system rather than within the ephemeral container.

## Directory Structure

```
mysql_project/
│── Dockerfile
│── .env
│── docker-compose.yml
```

## Files

### .env File

The environment variables configuration file contains:

```
MYSQL_ROOT_PASSWORD=rootpass
MYSQL_DATABASE=mydb
```

## Setup Instructions

1. **Create and Start MySQL Container**

   ```
   docker compose up -d
   ```

   This command builds the Docker image and starts the container in detached mode.

## Working with the Database

### Creating Test Data

You can add data to the MySQL database using the following command:

```
docker exec -it mysql-demo mysql -uroot -prootpass -e "CREATE DATABASE demo;"
docker exec -it mysql-demo mysql -uroot -prootpass -D demo -e "CREATE TABLE test (id INT, value VARCHAR(20));"
docker exec -it mysql-demo mysql -uroot -prootpass -D demo -e "SHOW TABLES;"

```

### Connecting to the Database

To connect to the MySQL database:

```
docker exec -it mysql-demo mysql -uroot -prootpass
```

### Executing SQL Commands

You can execute SQL commands directly:

```
docker exec -it mysql-demo mysql -uroot -prootpass -e "SELECT * FROM demo.test;"
```

## Testing Persistence

1. **Stop and remove containers**

   ```
   docker compose down
   ```

2. **Restart the containers**

   ```
   docker compose up -d
   ```

3. **Verify that data persisted**

   ```
   docker exec mysql-demo mysql -uroot -prootpass -e "SELECT * FROM demo.test;"
   ```

   If you see the previously added records, your persistent storage is working correctly.

## Network Connectivity

The MySQL container is accessible:
- Within the Docker network as `mysql-demo`
- From the host machine at `localhost:3306`

To connect from another container within the same network:

```
Host: mysql-demo
Port: 3306
User: root
Password: rootpass
Database: mydb
```



