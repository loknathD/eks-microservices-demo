<?php
// Enable error reporting for development
ini_set('display_errors', 0);
error_reporting(E_ALL);

// Set headers for JSON response
header('Content-Type: application/json');

// Health check endpoint
if ($_SERVER['REQUEST_URI'] === '/health') {
    echo json_encode(['status' => 'OK']);
    exit;
}

// Main endpoint
$response = [
    'message' => 'Hello from Service 3 (PHP)!',
    'timestamp' => date('c'),
    'version' => getenv('VERSION') ?: '1.0.0',
    'server' => php_uname('n')
];

// Error handling
try {
    echo json_encode($response, JSON_THROW_ON_ERROR);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Internal Server Error',
        'message' => 'Failed to generate response'
    ]);
}
?>