from http.server import HTTPServer, SimpleHTTPRequestHandler
from functools import partial
import os

class CORSHTTPRequestHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cross-Origin-Embedder-Policy', 'require-corp')
        self.send_header('Cross-Origin-Opener-Policy', 'same-origin')
        super().end_headers()

# 设置服务器的端口号
port = 8000

# 获取当前脚本所在目录
current_directory = os.path.dirname(os.path.realpath(__file__))

# 创建服务器，使用当前目录作为 HTML 文件目录
handler_class = partial(CORSHTTPRequestHandler, directory=current_directory)
httpd = HTTPServer(('localhost', port), handler_class)

print(f"Serving HTTP on port {port} from {current_directory}...")
httpd.serve_forever()
