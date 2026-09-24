from datetime import datetime, timezone
import os
from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def home():
    return jsonify(
        {
            "application": "CloudOps Forge",
            "status": "running",
            "environment": os.getenv("APP_ENV", "development"),
            "timestamp": datetime.now(timezone.utc).isoformat(),
        }
    )


@app.route("/health")
def health():
    return jsonify({"status": "healthy"})


@app.route("/version")
def version():
    return jsonify({"version": "1.0.0"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)