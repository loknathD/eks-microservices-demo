# Architecture Documentation

## Overview
This document outlines the architecture of the EKS microservices deployment, including infrastructure, security, monitoring, and CI/CD components.

## Infrastructure Components

### EKS Cluster
- Region: us-west-2
- Version: 1.27
- Node Type: t3.medium
- Node Count: 3 (minimum)
- Autoscaling: Enabled (3-5 nodes)

### Networking
- VPC: Custom VPC (10.0.0.0/16)
- Subnets: 3 private, 3 public
- NAT Gateway: Single NAT for cost optimization
- Network Policies: Zero-trust architecture

### Security
- IAM Roles: Least privilege principle
- Network Policies: Default deny with explicit allows
- Pod Security: Standard policies enforced
- Service Accounts: Kubernetes RBAC integration

## Application Architecture

### Microservices
1. Python Service (Flask)
   - Purpose: Basic HTTP service
   - Scaling: HPA enabled
   - Resource Limits: 200m CPU, 256Mi memory

2. Node.js Service (Express)
   - Purpose: Basic HTTP service
   - Scaling: Manual
   - Resource Limits: 200m CPU, 256Mi memory

3. PHP Service (Apache)
   - Purpose: Basic HTTP service
   - Scaling: Manual
   - Resource Limits: 200m CPU, 256Mi memory

### Service Communication
- Internal: Service discovery via Kubernetes Services
- External: Ingress Controller (NGINX)
- Protocol: HTTP/HTTPS

## CI/CD Pipeline

### Jenkins Pipeline Stages
1. Checkout
2. Build (Parallel)
3. Test
4. Push Images
5. Deploy

### Deployment Strategy
- Rolling updates
- Health checks
- Automated rollback capability

## Security Considerations

### Network Security
- Default deny network policies
- Explicit service-to-service communication
- External access through ingress only

### Access Control
- RBAC for Kubernetes resources
- IAM integration
- Service account limitations

### Container Security
- Image scanning
- Resource limitations
- Non-root containers

## Scalability

### Horizontal Pod Autoscaling
- CPU-based scaling
- Custom metrics support
- Configured thresholds

### Cluster Autoscaling
- Node group scaling
- Resource-based triggers
- Scaling limits


