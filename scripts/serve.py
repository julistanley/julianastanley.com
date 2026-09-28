#!/usr/bin/env python3
"""Local dev server: python3 scripts/serve.py [port]

Same as `python3 -m http.server` from the repo root, but with caching
disabled (Cache-Control: no-store), so edits to the JS modules show up on a
plain reload instead of being served from the browser cache.
"""
import http.server
import os
import sys

class NoStoreHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cache-Control', 'no-store')
        super().end_headers()

port = int(sys.argv[1]) if len(sys.argv) > 1 else 8766
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
print(f'http://localhost:{port}/')
http.server.ThreadingHTTPServer(('127.0.0.1', port), NoStoreHandler).serve_forever()
