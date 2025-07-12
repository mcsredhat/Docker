# SQLite Database with Persistent Storage
This project demonstrates how to deploy a SQLite database in a Docker container with persistent storage using volumes, ensuring your data survives container restarts.

## Overview
The setup uses Docker and Docker Compose to create a containerized SQLite database. Data persistence is achieved through Docker volumes, which store the database file on the host system rather than within the ephemeral container.

## Directory Structure

```
sqlite_project/
│── Dockerfile
│── init.sql
│── .env
│── docker-compose.yml
```

## Files

### init.sql

This file contains initial SQL commands that will be executed when the database is first created:

```
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);
INSERT INTO users (id, name) VALUES (1, 'Alice');
```

### .env
Environment variables configuration:

```
DB_FILE=/data/mydb.db
```

## Setup Instructions

1. **Create a Docker Volume**

   ```
   docker volume create db-volume
   ```

2. **Build and Run the Container**

   ```
   docker compose up -d
   ```

## Accessing the Database

To connect to the running SQLite database:

```
docker exec -it sqlite-demo sqlite3 /data/mydb.db
```

Once connected, you can run SQL commands directly:

```sql
SELECT * FROM users;
```

## Testing Persistence

1. **Add data to the database**

   ```
   docker exec -it sqlite-demo sqlite3 /data/mydb.db "INSERT INTO users (id, name) VALUES (2, 'Bob');"
   ```

2. **Verify data was added**

   ```
   docker exec -it sqlite-demo sqlite3 /data/mydb.db "SELECT * FROM users;"
   ```

3. **Restart the container**

   ```
   docker restart sqlite-demo
   ```

4. **Verify the data persisted**

   ```
   docker exec -it sqlite-demo sqlite3 /data/mydb.db "SELECT * FROM users;"
   ```

## Troubleooting

- **Volume not mounting properly**: Ensure the volume path in the docker-compose.yml matches the path in your Dockerfile and commands.
- **Database not initializing**: Check that the init.sql file is being properly copied and executed.
- **Permission issues**: You may need to adjust file permissions on the host or in the container.

