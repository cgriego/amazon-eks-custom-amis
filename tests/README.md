# E2E Tests

## Prerequisites

- [golang](https://go.dev/doc/install) 1.17+ installed and available in your `PATH`
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) 1.0+ installed and available in your `PATH`
- [Packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli) 1.8+ installed and available in your `PATH`
- AWS credentials

### Optional

The following are optional to format, lint, and validate Terraform codebase using `pre-commit run -a`:
- [pre-commit](https://github.com/antonbabenko/pre-commit-terraform#how-to-install) for running pre-commit checks/fixes
  - [tflint](https://github.com/terraform-linters/tflint) for linting Terraform code

## How to Execute

### Order of Operations

Note: The order is codified within the test suite.

1. VPC is created first to ensure we have a VPC for testing and not relying on an existing "default" VPC to be present
2. AMI is built and checks verified
3. EKS cluster is provisioned with AMI used in EKS Managed node groupe to validate the AMI in use in the cluster

## Notes

- Bootstrap script is provided by the [EKS module used](https://github.com/terraform-aws-modules/terraform-aws-eks). Using a custom AMI in an EKS managed node group requires users to provide their own bootstrap script; this module provides that functionality which is similar to EKS managed node group without custom AMI.
