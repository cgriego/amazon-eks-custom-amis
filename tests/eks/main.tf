provider "aws" {
  region = var.region
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.name}-*"]
  }
}

locals {
  tags = {
    GithubRepo = "github.com/aws-samples/amazon-eks-custom-amis"
  }
}

################################################################################
# EKS Cluster
################################################################################

module "eks_min" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.26"

  cluster_name    = "${var.name}-min"
  cluster_version = "1.19" # EKS minimum supported Kubernetes version

  vpc_id     = data.aws_vpc.vpc.id
  subnet_ids = data.aws_subnets.private.ids

  eks_managed_node_group_defaults = {
    # Nodes will use the cluster primary security group
    create_security_group                 = false
    attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {
    min_x86_64 = {
      ami_type = "AL2_x86_64"
      ami_id   = var.min_x86_64_ami_id

      # Add the boostrap user data to join the node to the cluster
      # due to use of custom AMI
      enable_bootstrap_user_data = true

      instance_types = ["c6i.large"]
      max_size       = 1
    }

    min_arm64 = {
      ami_type = "AL2_ARM_64"
      ami_id   = var.min_arm64_ami_id

      # Add the boostrap user data to join the node to the cluster
      # due to use of custom AMI
      enable_bootstrap_user_data = true

      instance_types = ["c6g.large"]
      max_size       = 1
    }
  }

  tags = local.tags
}
