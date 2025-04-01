# Equivalent docker CLI command: 
# docker pull python:3.9-slim
FROM python:3.9-slim

# Set environment variables to avoid writing bytecode and to disable buffering
# Also, set the environment to production
# Equivalent docker CLI command:
# docker build --build-arg PYTHONDONTWRITEBYTECODE=1 --build-arg PYTHONUNBUFFERED=1 --build-arg ENVIRONMENT=production .
ENV PYTHONDONTWRITEBYTECODE=1 \  
    PYTHONUNBUFFERED=1 \          
    ENVIRONMENT=production        

# Create a non-root user for security purposes
# Equivalent docker CLI command:
# docker run --user root --rm -it python:3.9-slim bash -c "useradd -m appuser"
RUN useradd -m appuser           

# Create and set the working directory inside the container
# Equivalent docker CLI command:
# docker run --rm -it -w /app python:3.9-slim bash
WORKDIR /app                     

# Install dependencies first to leverage Docker layer caching
# Equivalent docker CLI command:
# docker cp requirements.txt <container_id>:/app/
# docker exec -it <container_id> pip install --no-cache-dir -r /app/requirements.txt
COPY requirements.txt .          
RUN pip install --no-cache-dir -r requirements.txt  

# Copy the application code into the container
# Equivalent docker CLI command:
# docker cp src/ <container_id>:/app/src/
COPY src/ ./src/                 
# Switch to a non-root user to run the application (for security)
# Equivalent docker CLI command:
# docker exec -u appuser -it <container_id> bash
USER appuser                     

# Command to run the application (entry point of the container)
# Equivalent docker CLI command:
# docker run --rm python:3.9-slim python src/app.py
CMD ["python", "src/app.py"]    

# Expose the port that the application will listen on
# Equivalent docker CLI command:
# docker run -p 5000:5000 <container_id>
EXPOSE 5000                       