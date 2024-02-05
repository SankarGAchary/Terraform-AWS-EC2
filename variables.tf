variable "environment" {
  description = "Ec2 environment"
  default     = "dev"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to use if not creating VPC."
  default     = "aws-vpc"
  type        = string
}

variable "cidr_block" {
  description = "IPv4 CIDR range to assign to VPC if creating VPC or to associate as a secondary IPv6 CIDR. Overridden by var.vpc_id output from data.aws_vpc."
  type        = string
  default     = "10.0.0.0/16"

}

variable "azs" {
  description = "A list of availability zone names or ids in the region"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "instance_type" {
  description = "Ec2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami" {
  description = "Ec2 Ami"
  type        = string
  default     = "ami-0277155c3f0ab2930"
  
}



