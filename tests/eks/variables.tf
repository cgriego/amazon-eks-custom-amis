variable "region" {
  description = "AWS region where VPC resources will be created"
  type        = string
  default     = "us-west-2"
}

variable "name" {
  description = "Name given to the VPC as well as the EKS cluster name (one in the same)"
  type        = string
  default     = "eks-ami-e2e"
}

variable "min_x86_64_ami_id" {
  description = "AMI ID for x86_64 architecture and minimum supported Kubernetes version"
  type        = string
}

variable "min_arm64_ami_id" {
  description = "AMI ID for arm64 architecture and minimum supported Kubernetes version"
  type        = string
}
