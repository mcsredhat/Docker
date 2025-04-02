# Overview

This project sets up a Python Flask application connected to a Redis database inside Docker containers to simulate a scalable web environment.

Steps:

## Create a Flask application structure

mkdir -p flask-demo/app
cd flask-demo

Create a simple Flask application using Redis
Build the application image

docker build -t flask-redis-app:latest .

Start a Redis container

docker run -d --name redis redis:alpine

Start the Flask application container
docker run -it --name flask-app -p 5000:5000 --link redis flask-redis-app:latest

Test the application

curl <http://localhost:5000>

Stop the containers gracefully
docker stop flask-app redis

Restart the containers
docker restart redis
docker restart flask-app

This setup ensures a structured, scalable, and containerized web application environment using Docker. */
