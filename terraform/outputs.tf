output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = module.eks.cluster_arn
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "eks_node_group_arn" {
  description = "ARN of the EKS node group"
  value       = module.eks.eks_managed_node_groups["general"].node_group_arn
}

output "eks_node_group_status" {
  description = "Status of the EKS node group"
  value       = module.eks.eks_managed_node_groups["general"].status
}

output "eks_limited_user_role_arn" {
  description = "ARN of the limited EKS user role"
  value       = aws_iam_role.eks_user.arn
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "cluster_primary_security_group_id" {
  description = "Security group ID attached to the EKS cluster control plane"
  value       = module.eks.cluster_primary_security_group_id
}