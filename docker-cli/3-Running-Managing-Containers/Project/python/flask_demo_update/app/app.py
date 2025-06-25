from flask import Flask
import redis
import socket
import os

app = Flask(__name__)
cache = redis.Redis(host='redis', port=6379)

@app.route('/')
def hello():
    visits = cache.incr('visits')
    hostname = socket.gethostname()
    return f'Hello from Docker! This page has been viewed {visits} times.\nHostname: {hostname}\n'

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
