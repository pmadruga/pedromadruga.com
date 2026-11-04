"""Serve a clean production build with the site's actual security headers."""

from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import signal
import subprocess
import tempfile
import tomllib


ROOT = Path(__file__).resolve().parent.parent
with (ROOT / "netlify.toml").open("rb") as config:
    HEADERS = next(
        entry["values"]
        for entry in tomllib.load(config)["headers"]
        if entry["for"] == "/*"
    )


class SiteHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        for name, value in HEADERS.items():
            self.send_header(name, value)
        super().end_headers()

    def log_message(self, format, *args):
        pass


def stop(signum, frame):
    raise SystemExit(0)


signal.signal(signal.SIGTERM, stop)
with tempfile.TemporaryDirectory(prefix="hugo-browser-tests-") as temporary:
    output = Path(temporary) / "public"
    subprocess.run(
        [
            "hugo", "--minify", "--buildDrafts=false",
            "--baseURL", "http://127.0.0.1:4173/",
            "--destination", str(output),
            "--cacheDir", str(Path(temporary) / "cache"),
        ],
        cwd=ROOT,
        check=True,
    )
    handler = partial(SiteHandler, directory=str(output))
    with ThreadingHTTPServer(("127.0.0.1", 4173), handler) as server:
        server.serve_forever()
