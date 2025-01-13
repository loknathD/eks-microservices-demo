// app.js
const express = require('express');
const prometheus = require('prom-client');
const app = express();
const port = 3000;

// Create a Registry to register the metrics
const register = new prometheus.Registry();

// Create a counter for incoming requests
const httpRequestsTotal = new prometheus.Counter({
    name: 'http_requests_total',
    help: 'Total number of HTTP requests',
    labelNames: ['method', 'status'],
});

// Create a histogram for request duration
const httpRequestDurationSeconds = new prometheus.Histogram({
    name: 'http_request_duration_seconds',
    help: 'HTTP request duration in seconds',
    buckets: [0.1, 0.5, 1, 2, 5],
});

// Register the metrics
register.registerMetric(httpRequestsTotal);
register.registerMetric(httpRequestDurationSeconds);

// Health check endpoint
app.get('/health', (req, res) => {
    httpRequestsTotal.inc({ method: 'GET', status: 200 });
    res.status(200).send('OK');
});

// Main endpoint
app.get('/', (req, res) => {
    const end = httpRequestDurationSeconds.startTimer();
    
    // Simulate some processing
    setTimeout(() => {
        res.status(200).json({
            message: 'Hello from Node.js Service!',
            timestamp: new Date().toISOString(),
            version: process.env.VERSION || '1.0.0'
        });
        
        httpRequestsTotal.inc({ method: 'GET', status: 200 });
        end();
    }, Math.random() * 100);
});

// Metrics endpoint for Prometheus
app.get('/metrics', async (req, res) => {
    try {
        res.set('Content-Type', register.contentType);
        res.end(await register.metrics());
    } catch (err) {
        res.status(500).end(err);
    }
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({
        error: 'Something went wrong!',
        message: err.message
    });
});

app.listen(port, () => {
    console.log(`Node.js service listening at http://localhost:${port}`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
    console.log('Received SIGTERM. Performing graceful shutdown...');
    process.exit(0);
});