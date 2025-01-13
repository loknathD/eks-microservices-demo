#!/bin/bash

# Exit on any error
set -e

# Read arguments
SERVICE_NAME=$1
VERSION=$2
REGISTRY=$3

# Validate inputs
if [ -z "$SERVICE_NAME" ] || [ -z "$VERSION" ] || [ -z "$REGISTRY" ]; then
    echo "Usage: $0 <service-name> <version> <registry>"
    exit 1
fi

# Set working directory based on service
cd kubernetes/applications/${SERVICE_NAME}

# Build Docker image
echo "Building Docker image for ${SERVICE_NAME}..."
docker build -t ${REGISTRY}/${SERVICE_NAME}:${VERSION} .
docker tag ${REGISTRY}/${SERVICE_NAME}:${VERSION} ${REGISTRY}/${SERVICE_NAME}:latest

# Push Docker image
echo "Pushing Docker image to registry..."
docker push ${REGISTRY}/${SERVICE_NAME}:${VERSION}
docker push ${REGISTRY}/${SERVICE_NAME}:latest

echo "Build and push completed successfully for ${SERVICE_NAME}"