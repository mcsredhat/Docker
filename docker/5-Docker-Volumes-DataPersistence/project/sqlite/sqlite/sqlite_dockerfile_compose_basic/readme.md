# SQLite Database with Persistent Storage
## Project Overview
This project demonstrates deploying a SQLite database in a Docker container with persistent storage using Docker volumes. The setup ensures that your database data survives container restarts and removals.

## Features
- Containerized SQLite database
- Persistent data storage using Docker volumes
- Initialization script for database setup
- Docker Compose for easy deployment
- Environment variable configuration

## Prerequisites
- Docker Engine (version 19.03 or newer)
- Docker Compose (version 1.27 or newer)
- Basic understanding of SQL and Docker concepts

## Project Structure
```
sqlite_project/
├── Dockerfile          # Container configuration for SQLite
├── init.sql            # SQL initialization script
├── .env                # Environment variables
├── docker-compose.yml  # Docker Compose configuration
└── README.md           # This documentation
```

## Quick Start

### 1. Create a Volume
```
docker volume create db-volume
```

### 2. Build and Run the Container
```
docker build -t sqlite-demo .
```

```
docker compose up -d
```

### 3. Access the SQLite Database
```
docker exec -it sqlite-demo sqlite3 /data/mydb.db
```

Once inside the SQLite shell, you can run SQL commands such as:
```
SELECT * FROM users;
```

## Configuration Files

### Environment Variables (.env)
The `.env` file contains environment variables used by the application:
- `DB_FILE`: Location of the SQLite database file inside the container

### Initialization Script (init.sql)
The `init.sql` file contains SQL commands that are executed when initializing the database:
- Creates a `users` table with ID and name columns
- Inserts a sample user (Alice)

## Docker Compose Configuration
The Docker Compose file sets up the SQLite service with:
- Container name: sqlite-demo
- Volume mapping: db-volume -> /data
- Environment variables from .env file
- Custom command to run SQLite on the specified database file

## Data Persistence
This project demonstrates data persistence through Docker volumes:
1. Create a named volume with `docker volume create`
2. Mount the volume to the container's data directory
3. All changes to the database are stored in the volume
4. The data persists even when the container is stopped or removed

## Testing Persistence
To verify that data persists across container restarts:

1. Start the container and add data:
```
docker exec -it sqlite-demo sqlite3 /data/mydb.db
```

```
sqlite> INSERT INTO users (id, name) VALUES (2, 'Bob');
```

```
sqlite> .exit
```

2. Restart the container:
```
docker compose down
```

```
docker compose up -d
```

3. Check if the data still exists:
```
docker exec -it sqlite-demo sqlite3 /data/mydb.db
```

```
sqlite> SELECT * FROM users;
```

## Managing the Volume
- List volumes: `docker volume ls`
- Inspect volume: `docker volume inspect db-volume`
- Remove volume (will delete data): `docker volume rm db-volume`

## Troubleshooting
- **Permission issues**: Ensure the container user has access to the mounted volume
- **Missing data**: Verify that the correct volume is mounted to the container
- **Database not initializing**: Check if init.sql is properly copied to the container

