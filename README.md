# EKS Microservices Demo

This project demonstrates a production-ready Kubernetes deployment on AWS EKS, featuring microservices architecture, monitoring, and CI/CD integration.

## Architecture Overview

The deployment consists of three microservices:
- Service1: Python-based Hello World API
- Service2: Node.js-based Hello World API
- Service3: PHP-based Hello World API

All services are deployed on an EKS cluster with proper monitoring, security, and scaling configurations.

## Prerequisites

- AWS CLI configured with appropriate permissions
- kubectl installed
- Terraform >= 1.0.0
- Docker installed
- Jenkins server (for CI/CD)

## Quick Start

1. Initialize Terraform and create EKS cluster:
   cd terraform
   terraform init
   terraform apply