# WordPress with Persistent Content

## Project Overview
This project demonstrates how to deploy WordPress with persistent storage for both the database and content files using Docker containers and volumes. The setup ensures that your WordPress site remains intact during container restarts or upgrades.

## Features
- Containerized WordPress and MySQL deployment
- Persistent storage for both database and WordPress content
- Multi-container orchestration with Docker Compose
- Environment variable configuration
- Automatic container restart
- Container dependency management

## Prerequisites
- Docker Engine (version 19.03 or newer)
- Docker Compose (version 1.27 or newer)
- Basic understanding of WordPress and Docker concepts

## Project Structure
```
wordpress_project/
├── docker-compose.yml  # Docker Compose configuration
├── .env                # Environment variables
└── README.md           # This documentation
```

## Quick Start

### 1. Deploy WordPress and MySQL
```
docker compose up -d
```

### 2. Complete WordPress Setup
Open your web browser and navigate to:
```
http://localhost:8080
```
Follow the WordPress setup wizard to configure your site.

### 3. Create Content
Log in to the WordPress admin dboard and create posts, pages, install themes and plugins.

## Configuration Files

### Environment Variables (.env)
The `.env` file contains environment variables used by MySQL:
- `MYSQL_ROOT_PASSWORD`: Root user password for MySQL
- `MYSQL_DATABASE`: Database name for WordPress

### Docker Compose Configuration
The Docker Compose file sets up:
- MySQL 5.7 database service with persistent volume
- WordPress latest image with persistent content volume
- Service dependency (WordPress waits for MySQL)
- Port mapping: 8080 (host) -> 80 (container)
- Automatic restart of containers

## Data Persistence
This project uses two Docker volumes to ensure data persistence:
1. `wordpress-db`: Stores MySQL database files
2. `wordpress-content`: Stores WordPress content, including:
   - Themes
   - Plugins
   - Uploads
   - Custom code

This ensures that all your content and configurations survive container restarts and removals.

## Testing Persistence
To verify data persistence:

1. Create content in WordPress (posts, pages, etc.)
2. Stop and remove containers:
   ```
   docker compose down
   ```
3. Restart containers:
   ```
   docker compose up -d
   ```
4. Verify your content is still available at http://localhost:8080

## Backup and Restore

### Backup WordPress Content
```
docker run --rm -v wordpress-content:/source -v $(pwd):/backup alpine tar -czvf /backup/wp-content-backup.tar.gz -C /source .
```

### Backup Database
```
docker exec wordpress-db mysqldump -uroot -p<password> wordpress > wordpress-db-backup.sql
```

### Restore WordPress Content
```
docker run --rm -v wordpress-content:/target -v $(pwd):/backup alpine sh -c "tar -xzvf /backup/wp-content-backup.tar.gz -C /target"
```

### Restore Database
```
cat wordpress-db-backup.sql | docker exec -i wordpress-db mysql -uroot -p<password> wordpress
```

## Maintenance

### Updating WordPress
```
docker compose down
```
```
docker pull wordpress:latest
```
```
docker compose up -d
```

### Updating MySQL
```
docker compose down
```

```
docker pull mysql:5.7
```

```
docker compose up -d
```

## Cleanup
To remove containers and volumes:
```
docker compose down -v
```

To remove only containers but keep volumes (preserving data):
```
docker compose down
```

## Troubleshooting

### Common Issues
- **Database connection errors**: Check MySQL container status and environment variables
- **Permission issues**: Verify volume permissions for WordPress content
- **White screen of death**: Check WordPress error logs within the container
- **Container not starting**: Inspect logs with `docker logs wordpress` or `docker logs wordpress-db`

## WordPress Configuration Tips
- WP-Config file is located in the container at `/var/www/html/wp-config.php`
- For custom PHP configurations, consider adding a custom php.ini through volume mounting
- To modify upload limits, add a custom .htaccess file in the content volume

## Security Considerations
- Change the default MySQL password in the .env file
- Use a unique prefix for WordPress database tables
- Consider implementing SSL for production deployments
- Regularly update WordPress core, themes, and plugins

