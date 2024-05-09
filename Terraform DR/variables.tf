variable "region" {
  description = "The AWS region where resources will be created."
  default     = "il-central-1"
}

#### VPC ####
variable "vpc_tags" {
  description = "Tags for the VPC."
  type        = map(string)
  default     = {
    Name = "MainVPC"
  }
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "subnet_tags" {
  description = "Tags for the Subnet."
  type        = map(string)
  default     = {
    Name = "MainSubnet"
  }
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet."
  default     = "10.0.1.0/25"
}

variable "route_table_tags" {
  type    = map(string)
  default = {
    Name        = "Route_Table_NAME"
  }
}

#### EC2 ####

variable "instance_name" {
  description = "The name of the EC2 instance"
  type        = string
  default     = "INSTANCE_NAME"
}

variable "ec2_instance_type" {
  description = "The instance type for the EC2 instance."
  default     = "t3.micro"
}

variable "ami_id" {
  description = "The ID of the AMI to use for the instance"
  type        = string
  default     = "ami-06cfff5992addd62e"
}

variable "key_name" {
  description = "The name of the EC2 key pair to associate with the instance"
  type        = string
  default     = "test"
}

variable "on_prem_cidr" {
  description = "CIDR for the on-premises network"
  type        = string
  default    = "140.10.0.0/24"
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "SG_NAME"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "grwgregsdf"
}

