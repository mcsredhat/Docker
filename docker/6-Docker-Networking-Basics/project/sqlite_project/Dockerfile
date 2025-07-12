FROM nouchka/sqlite3:latest
WORKDIR /data
COPY init.sql /data/
RUN echo '#!/bin/sh\n\
echo "Initializing SQLite database..."\n\
if [ ! -f /data/mydb.db ]; then\n\
  echo "Creating new database"\n\
  sqlite3 /data/mydb.db < /data/init.sql\n\
  echo "Database initialized successfully"\n\
else\n\
  echo "Database already exists"\n\
fi\n\
echo "Container is now running. Use docker exec to connect."\n\
tail -f /dev/null' > /data/entrypoint.sh && \
chmod +x /data/entrypoint.sh

ENTRYPOINT ["/data/entrypoint.sh"]

