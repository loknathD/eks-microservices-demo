#!/bin/bash

# Exit on any error
set -e

# Read arguments
CLUSTER_NAME=$1
REGION=$2
SERVICE_NAME=$3
VERSION=$4

# Validate inputs
if [ -z "$CLUSTER_NAME" ] || [ -z "$REGION" ] || [ -z "$SERVICE_NAME" ] || [ -z "$VERSION" ]; then
    echo "Usage: $0 <cluster-name> <region> <service-name> <version>"
    exit 1
fi

# Configure kubectl
echo "Configuring kubectl for EKS cluster..."
aws eks update-kubeconfig --name ${CLUSTER_NAME} --region ${REGION}

# Update deployment image
echo "Updating deployment for ${SERVICE_NAME}..."
kubectl set image deployment/${SERVICE_NAME} ${SERVICE_NAME}=${SERVICE_NAME}:${VERSION}

# Wait for rollout
echo "Waiting for deployment rollout..."
kubectl rollout status deployment/${SERVICE_NAME}

# Verify deployment
echo "Verifying deployment..."
kubectl get deployment ${SERVICE_NAME}

echo "Deployment completed successfully for ${SERVICE_NAME}"