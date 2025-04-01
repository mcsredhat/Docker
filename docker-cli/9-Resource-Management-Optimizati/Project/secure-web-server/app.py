import http.server
import socketserver
import os

PORT = int(os.getenv("PORT", 8000))
MAX_CONNECTIONS = int(os.getenv("MAX_CONNECTIONS", 100))

class CustomHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

Handler = CustomHTTPRequestHandler
socketserver.TCPServer.allow_reuse_address = True

with socketserver.ThreadingTCPServer(("", PORT), Handler) as httpd:
    print(f"Serving at port {PORT}")
    httpd.socket.setsockopt(socketserver.socket.SOL_SOCKET, socketserver.socket.SO_REUSEADDR, 1)
    httpd.server_name = "SecurePythonServer"
    httpd.max_children = MAX_CONNECTIONS
    httpd.serve_forever()