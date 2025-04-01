FROM nginx:1.23-alpine

# Update packages to patch vulnerabilities
RUN apk update && apk upgrade && apk add --no-cache shadow

# Create a dedicated non-root user
RUN groupadd -g 1001 nginxgroup && \ 
    useradd -u 1001 -g nginxgroup -s /bin/false -M nginxuser

# Configure Nginx to run as non-root
RUN sed -i 's/user  nginx;/user  nginxuser;/' /etc/nginx/nginx.conf && \
    touch /var/run/nginx.pid && \
    chown -R nginxuser:nginxgroup /var/run/nginx.pid && \
    chown -R nginxuser:nginxgroup /var/cache/nginx

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN chown -R nginxuser:nginxgroup /etc/nginx/conf.d

# Set correct permissions for web content
COPY --chown=nginxuser:nginxgroup html/ /usr/share/nginx/html/

# Expose non-privileged port
EXPOSE 8080

# Run as non-root user
USER nginxuser
CMD ["nginx", "-g", "daemon off;"]