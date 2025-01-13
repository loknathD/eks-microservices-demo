from flask import Flask, jsonify
from prometheus_client import Counter, Histogram, generate_latest
import os
from datetime import datetime
import logging

app = Flask(__name__)

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Prometheus metrics
REQUEST_COUNT = Counter(
    'http_requests_total',
    'Total number of HTTP requests',
    ['method', 'endpoint', 'status']
)

REQUEST_LATENCY = Histogram(
    'http_request_duration_seconds',
    'HTTP request duration in seconds',
    ['endpoint']
)

@app.route('/health')
def health_check():
    REQUEST_COUNT.labels('GET', 'health', '200').inc()
    return jsonify({'status': 'healthy'})

@app.route('/metrics')
def metrics():
    return generate_latest()

@app.route('/')
@REQUEST_LATENCY.labels('root').time()
def hello():
    try:
        response = {
            'message': 'Hello from Service 1 (Python)!',
            'timestamp': datetime.utcnow().isoformat(),
            'version': os.getenv('VERSION', '1.0.0')
        }
        REQUEST_COUNT.labels('GET', 'root', '200').inc()
        return jsonify(response)
    except Exception as e:
        logger.error(f"Error in root endpoint: {str(e)}")
        REQUEST_COUNT.labels('GET', 'root', '500').inc()
        return jsonify({
            'error': 'Internal Server Error',
            'message': str(e)
        }), 500

@app.errorhandler(404)
def not_found(error):
    REQUEST_COUNT.labels('GET', 'unknown', '404').inc()
    return jsonify({
        'error': 'Not Found',
        'message': 'The requested resource was not found'
    }), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)