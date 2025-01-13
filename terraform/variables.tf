variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-microservices-demo"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.27"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "eks_node_instance_types" {
  description = "Instance types for EKS node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_node_desired_size" {
  description = "Desired size of EKS node group"
  type        = number
  default     = 3
}

variable "eks_node_min_size" {
  description = "Minimum size of EKS node group"
  type        = number
  default     = 3
}

variable "eks_node_max_size" {
  description = "Maximum size of EKS node group"
  type        = number
  default     = 5
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default     = "Production"
}

variable "project" {
  description = "Project name for tagging"
  type        = string
  default     = "EKS-Demo"
}