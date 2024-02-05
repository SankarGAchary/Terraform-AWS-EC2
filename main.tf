terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.33.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


# Create VPC Terraform Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  # VPC Basic Details
  name = "vpc-${var.environment}"
  #cidr = "10.0.0.0/16"
  cidr = var.cidr_block 
  #azs                 = ["us-east-1a", "us-east-1b", "us-east-1c"]
  azs                 = var.azs
  #public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  #private_subnets      = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  public_subnets      = var.public_subnets
  private_subnets      = var.private_subnets

  # NAT Gateways - Outbound Communication
  enable_nat_gateway = false
  single_nat_gateway = false

  public_subnet_tags = {
    Type = "public-subnets"
  }

  private_subnet_tags = {
    Type = "private-subnets"
  }

  tags = {
    Owner = "aws-dev-env"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "vpc-dev"
  }
}


# EC2 Instances that will be created in VPC Private Subnets
module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.0"
  name = "${var.environment}-vm"
  ami = var.ami
  instance_type = var.instance_type
  #user_data = file("${path.module}/apache-install.sh")
  #key_name = var.instance_keypa
  #subnet_id = module.vpc.private_subnets[0] # Single Instance
  #vpc_security_group_ids = [module.private_sg.this_security_group_id]    
  #instance_count = 1
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.public_sg.security_group_id]

  #tags = local.common_tags
}

# AWS EC2 Security Group Terraform Module
# Security Group for Private EC2 Instances
module "public_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "public-sg"
  description = "Security group with HTTP & SSH ports open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = module.vpc.vpc_id
  ingress_rules = ["ssh-tcp", "http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]
   
}

