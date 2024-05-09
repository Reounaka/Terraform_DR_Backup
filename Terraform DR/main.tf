# Include variables
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      
    }
  }
}

provider "aws" {
  region = var.region
}

################################################# Create Vpc ################################################
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = var.vpc_tags

}

################################################# Create Subnet ################################################
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr_block
  tags = var.subnet_tags
}

################################################# Create Instance ################################################
resource "aws_instance" "example" {
  instance_type = var.ec2_instance_type
  subnet_id = aws_subnet.main.id
  ami           = var.ami_id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.security_group.id]
  tags = {
    Name = var.instance_name
  }
  depends_on = [
    aws_vpc.main,
    aws_subnet.main
  ]

}

################################################# Create Endpoint Gateway s3 ################################################
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.il-central-1.s3"
}


################################################# Create Security Group ################################################
resource "aws_security_group" "security_group" {
    name = var.security_group_name  
    vpc_id      = aws_vpc.main.id 
    
  ingress {
    from_port   = 135
    to_port     = 139
    protocol    = "tcp"
    cidr_blocks = [var.on_prem_cidr, var.subnet_cidr_block]
  }

  ingress {
    from_port   = 8400
    to_port     = 8408
    protocol    = "tcp"
    cidr_blocks = [var.on_prem_cidr, var.subnet_cidr_block]
  }

  ingress {
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = [var.on_prem_cidr, var.subnet_cidr_block]
  }
}


################################################ Role ########################################################################

resource "aws_iam_role" "ec2_commvault_MA_Role" {
  name = "ec2_commvault_MA_Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

module "policies" {
  source = "./policy"
}

resource "aws_iam_role_policy_attachment" "ec2_commvault_MA_Role-attachec2" {
  role       = aws_iam_role.ec2_commvault_MA_Role.name
  policy_arn = module.policies.commvault_ec2_policy_arn
}

resource "aws_iam_role_policy_attachment" "ec2_commvault_MA_Role-attachs3" {
  role       = aws_iam_role.ec2_commvault_MA_Role.name
  policy_arn = module.policies.commvault_s3_policy_arn
}


################################################ S3 ########################################################################

resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.example.id

  policy = <<POLICY
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Principal": {"AWS":["${aws_iam_role.ec2_commvault_MA_Role.arn}"]},
			"Effect": "Allow",
			"Action": [
				"s3:*"
			],
			"Resource": [
				"${aws_s3_bucket.example.arn}",
				"${aws_s3_bucket.example.arn}/*"
			]
		}
	]
}
POLICY
}
################################################# Create Route Table ################################################
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id
  tags   = var.route_table_tags
}

resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.example.id
}




