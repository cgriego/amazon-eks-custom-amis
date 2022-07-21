variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "data_volume_size" {
  type    = string
  default = "50"
}

variable "eks_version" {
  type    = string
  default = "1.18"
}

variable "http_proxy" {
  type    = string
  default = ""
}

variable "https_proxy" {
  type    = string
  default = ""
}

variable "no_proxy" {
  type    = string
  default = ""
}

variable "root_volume_size" {
  type    = string
  default = "10"
}

variable "source_ami_arch" {
  type    = string
  default = "x86_64"
}

variable "source_ami_owner" {
  type    = string
  default = "602401143452"
}

variable "source_ami_owner_govcloud" {
  type    = string
  default = "219670896067"
}

variable "source_ami_ssh_user" {
  type    = string
  default = "ec2-user"
}

variable "subnet_id" {
  type    = string
  default = null
}

variable "instance_type" {
  type    = string
  default = "c6i.large"
}

variable "ami_name_prefix" {
  type    = string
  default = "amazon-eks-node"
}
