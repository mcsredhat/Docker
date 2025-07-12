import os
from wsgiref.simple_server import make_server

PORT = int(os.getenv("PORT", 8000))
DEBUG = os.getenv("DEBUG", "false").lower() == "true"

def application(environ, start_response):
    """Simple WSGI application"""
    status = '200 OK'
    headers = [('Content-type', 'text/plain; charset=utf-8')]
    start_response(status, headers)
    return [b'Secure Python Server Running!\n']

if __name__ == '__main__':
    # For development - use built-in server
    with make_server('', PORT, application) as httpd:
        print(f"Serving at port {PORT}")
        httpd.serve_forever()

# For production - gunicorn will use the 'application' function
