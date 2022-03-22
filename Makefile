
PACKER_VARIABLES := binary_bucket_name binary_bucket_region eks_version eks_build_date cni_plugin_version root_volume_size data_volume_size hardening_flag http_proxy https_proxy no_proxy
VPC_ID := vpc-04421521831249174
SUBNET_ID := subnet-049ea2459d1e821a1
SECURITY_GROUP := sg-0d2795ad6a120d9ff
INSTANCE_PROFILE := ManagedInstanceSSM
AWS_REGION := us-east-2
PACKER_FILE := 

EKS_BUILD_DATE := 2020-11-02
EKS_115_VERSION := 1.15.12
EKS_116_VERSION := 1.16.15
EKS_117_VERSION := 1.17.12
EKS_118_VERSION := 1.18.9
EKS_119_VERSION := 1.19.15
EKS_119_BUILD_DATE := 2021-11-10

EKS_VERSION := 1.19

MAKEFLAGS += -j8

build:
	packer build \
		--var 'aws_region=$(AWS_REGION)' \
		--var 'vpc_id=$(VPC_ID)' \
		--var 'subnet_id=$(SUBNET_ID)' \
		--var 'security_group_id=$(SECURITY_GROUP)' \
		--var 'iam_instance_profile=$(INSTANCE_PROFILE)' \
		$(foreach packerVar,$(PACKER_VARIABLES), $(if $($(packerVar)),--var $(packerVar)='$($(packerVar))',)) \
		$(PACKER_FILE)

all-1.16:
	$(MAKE) build-al2-1.16
	$(MAKE) build-ubuntu1804-1.16
	$(MAKE) build-ubuntu2004-1.16
	$(MAKE) build-rhel7-1.16
	$(MAKE) build-rhel8-1.16
	$(MAKE) build-centos7-1.16
	$(MAKE) build-centos8-1.16


all-1.17:
	$(MAKE) build-al2-1.17
	$(MAKE) build-ubuntu1804-1.17
	$(MAKE) build-ubuntu2004-1.17
	$(MAKE) build-rhel7-1.17
	$(MAKE) build-rhel8-1.17
	$(MAKE) build-centos7-1.17
	$(MAKE) build-centos8-1.17


all-1.18:
	$(MAKE) build-al2-1.18
	$(MAKE) build-ubuntu1804-1.18
	$(MAKE) build-ubuntu2004-1.18
	$(MAKE) build-rhel7-1.18
	$(MAKE) build-rhel8-1.18
	$(MAKE) build-centos7-1.18
	$(MAKE) build-centos8-1.18

all-1.19:
	$(MAKE) build-al2-1.19
	$(MAKE) build-ubuntu1804-1.19
	$(MAKE) build-ubuntu2004-1.19
	$(MAKE) build-rhel7-1.19
	$(MAKE) build-rhel8-1.19
	$(MAKE) build-centos7-1.19
	$(MAKE) build-centos8-1.19

# Amazon Linux 2
#-----------------------------------------------------
build-al2-1.15:
	$(MAKE) build PACKER_FILE=amazon-eks-node-al2.json eks_version=1.15

build-al2-1.16:
	$(MAKE) build PACKER_FILE=amazon-eks-node-al2.json eks_version=1.16

build-al2-1.17:
	$(MAKE) build PACKER_FILE=amazon-eks-node-al2.json eks_version=1.17

build-al2-1.18:
	$(MAKE) build PACKER_FILE=amazon-eks-node-al2.json eks_version=1.18

build-al2-1.19:
	$(MAKE) build PACKER_FILE=amazon-eks-node-al2.json eks_version=1.19

# Ubuntu 18.04
#-----------------------------------------------------
build-ubuntu1804-1.15:
	$(MAKE) build PACKER_FILE=amazon-eks-node-ubuntu1804.json eks_version=$(EKS_115_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-ubuntu1804-1.16:
	$(MAKE) build PACKER_FILE=amazon-eks-node-ubuntu1804.json eks_version=$(EKS_116_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-ubuntu1804-1.17:
	$(MAKE) build PACKER_FILE=amazon-eks-node-ubuntu1804.json eks_version=$(EKS_117_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-ubuntu1804-1.18:
	$(MAKE) build PACKER_FILE=amazon-eks-node-ubuntu1804.json eks_version=$(EKS_118_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-ubuntu1804-1.19:
	$(MAKE) build PACKER_FILE=amazon-eks-node-ubuntu1804.json eks_version=$(EKS_119_VERSION) eks_build_date=2021-01-05

# Ubuntu 20.04
#-----------------------------------------------------
build-ubuntu2004-1.15:
	$(MAKE) build PACKER_FILE=amazon-eks-node-ubuntu2004.json eks_version=$(EKS_115_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-ubuntu2004-1.16:
	$(MAKE) build PACKER_FILE=amazon-eks-node-ubuntu2004.json eks_version=$(EKS_116_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-ubuntu2004-1.17:
	$(MAKE) build PACKER_FILE=amazon-eks-node-ubuntu2004.json eks_version=$(EKS_117_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-ubuntu2004-1.18:
	$(MAKE) build PACKER_FILE=amazon-eks-node-ubuntu2004.json eks_version=$(EKS_118_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-ubuntu2004-1.19:
	$(MAKE) build PACKER_FILE=amazon-eks-node-ubuntu2004.json eks_version=$(EKS_119_VERSION) eks_build_date=2021-01-05

# RHEL 7
#-----------------------------------------------------
build-rhel7-1.15:
	$(MAKE) build PACKER_FILE=amazon-eks-node-rhel7.json eks_version=$(EKS_115_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-rhel7-1.16:
	$(MAKE) build PACKER_FILE=amazon-eks-node-rhel7.json eks_version=$(EKS_116_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-rhel7-1.17:
	$(MAKE) build PACKER_FILE=amazon-eks-node-rhel7.json eks_version=$(EKS_117_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-rhel7-1.18:
	$(MAKE) build PACKER_FILE=amazon-eks-node-rhel7.json eks_version=$(EKS_118_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-rhel7-1.19:
	$(MAKE) build PACKER_FILE=amazon-eks-node-rhel7.json eks_version=$(EKS_119_VERSION) eks_build_date=2021-01-05

# RHEL 8
#-----------------------------------------------------
build-rhel8-1.15:
	$(MAKE) build PACKER_FILE=amazon-eks-node-rhel8.json eks_version=$(EKS_115_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-rhel8-1.16:
	$(MAKE) build PACKER_FILE=amazon-eks-node-rhel8.json eks_version=$(EKS_116_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-rhel8-1.17:
	$(MAKE) build PACKER_FILE=amazon-eks-node-rhel8.json eks_version=$(EKS_117_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-rhel8-1.18:
	$(MAKE) build PACKER_FILE=amazon-eks-node-rhel8.json eks_version=$(EKS_118_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-rhel8-1.19:
	$(MAKE) build PACKER_FILE=amazon-eks-node-rhel8.json eks_version=$(EKS_119_VERSION) eks_build_date=2021-01-05

# CentOS 7
#-----------------------------------------------------
build-centos7-1.15:
	$(MAKE) build PACKER_FILE=amazon-eks-node-centos7.json eks_version=$(EKS_115_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-centos7-1.16:
	$(MAKE) build PACKER_FILE=amazon-eks-node-centos7.json eks_version=$(EKS_116_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-centos7-1.17:
	$(MAKE) build PACKER_FILE=amazon-eks-node-centos7.json eks_version=$(EKS_117_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-centos7-1.18:
	$(MAKE) build PACKER_FILE=amazon-eks-node-centos7.json eks_version=$(EKS_118_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-centos7-1.19:
	$(MAKE) build PACKER_FILE=amazon-eks-node-centos7.json eks_version=$(EKS_119_VERSION) eks_build_date=2021-01-05

# CentOS 8
#-----------------------------------------------------
build-centos8-1.15:
	$(MAKE) build PACKER_FILE=amazon-eks-node-centos8.json eks_version=$(EKS_115_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-centos8-1.16:
	$(MAKE) build PACKER_FILE=amazon-eks-node-centos8.json eks_version=$(EKS_116_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-centos8-1.17:
	$(MAKE) build PACKER_FILE=amazon-eks-node-centos8.json eks_version=$(EKS_117_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-centos8-1.18:
	$(MAKE) build PACKER_FILE=amazon-eks-node-centos8.json eks_version=$(EKS_118_VERSION) eks_build_date=$(EKS_BUILD_DATE)

build-centos8-1.19:
	$(MAKE) build PACKER_FILE=amazon-eks-node-centos8.json eks_version=$(EKS_119_VERSION) eks_build_date=2021-01-05


# Windows 1809 Full
#-----------------------------------------------------
build-windows1809full-1.16:
	$(MAKE) build PACKER_FILE=amazon-eks-node-windows1809full.json eks_version=1.16

build-windows1809full-1.17:
	$(MAKE) build PACKER_FILE=amazon-eks-node-windows1809full.json eks_version=1.17

build-windows1809full-1.18:
	$(MAKE) build PACKER_FILE=amazon-eks-node-windows1809full.json eks_version=1.18

build-windows1809full-1.19:
	$(MAKE) build PACKER_FILE=amazon-eks-node-windows1809full.json eks_version=1.19

# Windows 1809 Core
#-----------------------------------------------------
build-windows1809core-1.16:
	$(MAKE) build PACKER_FILE=amazon-eks-node-windows1809core.json eks_version=1.16

build-windows1809core-1.17:
	$(MAKE) build PACKER_FILE=amazon-eks-node-windows1809core.json eks_version=1.17

build-windows1809core-1.18:
	$(MAKE) build PACKER_FILE=amazon-eks-node-windows1809core.json eks_version=1.18

build-windows1809core-1.19:
	$(MAKE) build PACKER_FILE=amazon-eks-node-windows1809core.json eks_version=1.19

# Windows 2004 Core
#-----------------------------------------------------
build-windows2004core-1.16:
	$(MAKE) build PACKER_FILE=amazon-eks-node-windows2004core.json eks_version=1.16

build-windows2004core-1.17:
	$(MAKE) build PACKER_FILE=amazon-eks-node-windows2004core.json eks_version=1.17

build-windows2004core-1.18:
	$(MAKE) build PACKER_FILE=amazon-eks-node-windows2004core.json eks_version=1.18

build-windows2004core-1.19:
	$(MAKE) build PACKER_FILE=amazon-eks-node-windows2004core.json eks_version=1.19

define build_ami
	packer build \
		--var 'aws_region=$(AWS_REGION)' \
		--var 'vpc_id=$(VPC_ID)' \
		--var 'subnet_id=$(SUBNET_ID)' \
		--var 'security_group_id=$(SECURITY_GROUP)' \
		--var 'iam_instance_profile=$(INSTANCE_PROFILE)' \
		--var 'eks_version=$(EKS_VERSION)' \
		$(foreach packerVar,$(PACKER_VARIABLES), $(if $($(packerVar)),--var $(packerVar)='$($(packerVar))',)) \
		$(1)
endef

LINUX_AMIS = amazon-eks-node-linux-al2-arm64 \
amazon-eks-node-linux-al2 \
amazon-eks-node-linux-centos7 \
amazon-eks-node-linux-centos8 \
amazon-eks-node-linux-rhel7 \
amazon-eks-node-linux-rhel8 \
amazon-eks-node-linux-ubuntu1804 \
amazon-eks-node-linux-ubuntu2004

.PHONY: linux-amis
linux-amis: $(LINUX_AMIS)

amazon-eks-node-linux-al%: amazon-eks-node-linux-al%.json
	$(call build_ami,$<,$(EKS_VERSION))

amazon-eks-node-linux%: amazon-eks-node-linux%.json
	#Dynamic fetching of build-date : aws s3 ls amazon-eks/1.19.13/2021-09-02/bin/linux/amd64/ --region=us-west-2
	eks_build_date=${EKS_$(subst .,,$(EKS_VERSION))_BUILD_DATE}
	$(call build_ami,$<,$(EKS_VERSION), $(eks_build_date))