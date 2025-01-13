# EKS Microservices Infrastructure Project

This project implements a production-ready Kubernetes infrastructure on AWS EKS, featuring multiple microservices and automated CI/CD pipelines. The implementation follows infrastructure as code principles using Terraform and maintains security best practices throughout the stack.

## Architecture Overview

The infrastructure consists of several key components managed through different tools:

### Terraform-Managed Components

Our infrastructure foundation is managed through Terraform, ensuring consistent and version-controlled cloud resource provisioning:

1. EKS Cluster Configuration
   - A managed Kubernetes cluster with three worker nodes
   - Node groups configured with t3.medium instances
   - Auto-scaling capabilities from 3 to 5 nodes

2. Networking Infrastructure
   - Custom VPC with public and private subnets
   - NAT Gateways for private subnet connectivity
   - Security group configurations

3. IAM Configuration
   - Cluster service role
   - Node group execution role
   - Restricted user access role
   - Load balancer controller role

### Jenkins-Managed Components

Our CI/CD pipeline automated through Jenkins handles:

1. Application Deployments
   - Automated building of container images
   - Deployment to EKS cluster
   - Rolling updates with zero downtime

2. Testing and Validation
   - Application testing
   - Container security scanning
   - Deployment verification

### Kubernetes Resources

The cluster hosts several components managed through Kubernetes manifests:

1. Microservices
   - Service1: Python Flask application
   - Service2: Node.js Express application
   - Service3: PHP application

2. Network Policies
   - Default deny policy
   - Internal communication rules

3. Ingress Configuration
   - NGINX ingress controller
   - Path-based routing

## Prerequisites

Before beginning the setup, ensure you have the following tools installed:

1. AWS CLI (version 2.0 or later)
2. Terraform (version 1.0.0 or later)
3. kubectl (version compatible with your EKS cluster)
4. Docker (version 20.10 or later)
5. Jenkins (version 2.375 or later)

## Setup Instructions

### 1. Infrastructure Provisioning

First, initialize and apply the Terraform configuration:

cd terraform
terraform init
terraform plan
terraform apply


This will create:
- EKS cluster
- VPC and networking components
- IAM roles and policies
- Load balancer controller

### 2. Kubernetes Configuration

After the infrastructure is provisioned, configure kubectl:

aws eks update-kubeconfig --name eks-microservices-demo --region <your-region>


Apply the Kubernetes configurations in the following order:

1. RBAC Configuration:

kubectl apply -f kubernetes/RBAC/restricted-user-rbac.yaml


2. Network Policies:

kubectl apply -f kubernetes/config/network-policies/


3. Ingress Controller:

kubectl apply -f kubernetes/config/ingress/ingress-setup.yaml


4. Autoscaling Configuration:

kubectl apply -f kubernetes/config/autoscaling/hpa-service1.yaml


### 3. Application Deployment

The applications can be deployed either manually or through Jenkins:

#### Manual Deployment:

# For each service
kubectl apply -f kubernetes/applications/service1/
kubectl apply -f kubernetes/applications/service2/
kubectl apply -f kubernetes/applications/service3/


#### Jenkins Deployment:
1. Configure Jenkins credentials:
   - AWS credentials
   - Docker registry credentials
   - Kubernetes configuration

2. Create a new pipeline using the provided Jenkinsfile

3. Trigger the pipeline to deploy all services

## Usage Guide

### Accessing the Applications

After deployment, services are accessible through the ingress controller:

- Service1: `http://<ingress-ip>/service1`
- Service2: `http://<ingress-ip>/service2`
- Service3: `http://<ingress-ip>/service3`

To get the ingress IP:

kubectl get ingress microservices-ingress


### Monitoring and Management

1. Check service status:

kubectl get pods
kubectl get services


2. View application logs:

kubectl logs -f deployment/service1


3. Monitor autoscaling:

kubectl get hpa


### Security Management

1. IAM User Access:
   - Use the restricted user credentials for read-only access
   - Access is limited to viewing resources only

2. Network Policy Verification:

kubectl describe networkpolicy default-deny
kubectl describe networkpolicy allow-internal


## Maintenance and Updates

### Infrastructure Updates

For infrastructure changes:
1. Modify Terraform configurations
2. Run `terraform plan` to review changes
3. Apply changes with `terraform apply`

### Application Updates

Through Jenkins pipeline:
1. Push code changes to repository
2. Jenkins will automatically:
   - Build new container images
   - Deploy updated applications
   - Verify deployment success

## Troubleshooting

Common issues and solutions:

1. Ingress Not Accessible:
   - Check ingress controller pods: `kubectl get pods -n ingress-nginx`
   - Verify service endpoints: `kubectl get endpoints`

2. Pod Scaling Issues:
   - Check HPA status: `kubectl describe hpa`
   - Verify metrics server: `kubectl get apiservice v1beta1.metrics.k8s.io`

3. Network Policy Issues:
   - Test connectivity between pods
   - Review policy logs: `kubectl logs -n kube-system calico-node-xxxxx`

## Cleanup

To remove all resources:

1. Delete Kubernetes resources:

kubectl delete -f kubernetes/


2. Destroy infrastructure:

cd terraform
terraform destroy


## Project Structure


├── jenkins/                  # CI/CD Configuration
├── kubernetes/              # Kubernetes Manifests
│   ├── applications/       # Microservices
│   ├── config/            # Cluster Configuration
│   └── RBAC/             # Access Control
└── terraform/             # Infrastructure as Code

Note - please use your own access keys/secret accesskeys/docker credentails/, i have removed my credentails and only dummy credentails are used in the code. Thanks