# Overview

This project demonstrates how to build, tag, and run a Dockerized Python application across multiple environments (development, staging, and production) while following best practices.

## Steps to Set Up & Run

1. Create Project Structure
   - Organize application files and dependencies.

2. Build the Docker Image

   docker build -t myapp:latest .

3. Tag the Image for Different Environments

   VERSION="1.0.0"
   docker tag myapp:latest myapp:$VERSION
   docker tag myapp:latest myapp:$VERSION-dev
   docker tag myapp:latest myapp:$VERSION-staging

4. Save & Transfer Development Image

   docker save -o myapp-dev.tar myapp:$VERSION-dev

5. Push to Docker Hub
   docker tag myapp:$VERSION your-dockerhub-username/myapp:$VERSION
   docker push your-dockerhub-username/myapp:$VERSION

6. Run Containers in Different Environments

   docker run -d -p 5001:5000 -e ENVIRONMENT=development --name myapp-dev myapp:$VERSION-dev
   docker run -d -p 5002:5000 -e ENVIRONMENT=staging --name myapp-staging myapp:$VERSION-staging
   docker run -d -p 5003:5000 -e ENVIRONMENT=production --name myapp-prod myapp:$VERSION

 ### Access the Application

- Development: [http://localhost:5001](http://localhost:5001)
- Staging: [http://localhost:5002](http://localhost:5002)
- Production: [http://localhost:5003](http://localhost:5003)
