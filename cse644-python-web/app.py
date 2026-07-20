from http.server import HTTPServer, BaseHTTPRequestHandler

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        html = """
        <h1>CSE644 Python Web Server</h1>
        <p>Running on port 8888 inside Docker Container</p>
        <p>Student: wanlingj</p>
        """
        self.wfile.write(html.encode())

# 固定监听0.0.0.0:8888
if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 8888), Handler)
    print("Web server listening on port 8888")
    server.serve_forever()
