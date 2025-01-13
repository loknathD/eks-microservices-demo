provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = "eks-vpc"
  cidr = "10.0.0.0/16"
  
  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  
  enable_nat_gateway = true
  single_nat_gateway = true
  
  tags = {
    Environment = "Production"
    Project     = "EKS-Demo"
  }
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  
  cluster_name    = "eks-microservices-demo"
  cluster_version = "1.27"
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  
  eks_managed_node_groups = {
    general = {
      desired_size = 3
      min_size     = 3
      max_size     = 5
      
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }
  
  tags = {
    Environment = "Production"
    Project     = "EKS-Demo"
  }
}

# IAM role for EKS user with limited permissions
resource "aws_iam_role" "eks_user" {
  name = "eks-limited-user"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "eks_user_policy" {
  name = "eks-limited-policy"
  role = aws_iam_role.eks_user.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:ListUpdates",
          "eks:AccessKubernetesApi"
        ]
        Resource = "*"
      }
    ]
  })
}