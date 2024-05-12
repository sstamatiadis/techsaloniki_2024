###############################
## Define Terraform settings ##
###############################

terraform {
  # Terraform version
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # AWS Terraform provider version
      version = "~> 4.16"
    }
  }
}

####################################
## Define provider (AWS) settings ##
####################################

provider "aws" {
  # Define default tags for better tracking of all resources
  default_tags {
    tags = {
      Project     = var.tag_project     # Notice how we use a variable expression
      Environment = var.tag_environment # Notice how we use a variable expression
    }
  }
  region     = "eu-west-1" # Target region is Ireland
  access_key = ""          # Input via environment variable instead - `export AWS_ACCESS_KEY_ID=`
  secret_key = ""          # Input via environment variable instead - `export AWS_SECRET_ACCESS_KEY=`
}

#####################################
## Define infrastructure resources ##
#####################################

# This is our webserver (wordpress blog)
resource "aws_instance" "app_server" {
  ami             = "ami-06f6035668beecc88" # bitnami-wordpress-6.5.2-6-r06-linux-debian-12-x86_64-hvm-ebs-nami
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.http_sg.name] # Notice how we refer to the output name of the security group resource

  # Extra tags other than the default we apply
  tags = {
    Name = "TechSaloniki_VM" # Per AWS, this Name tag, also sets name that appears on the AWS Web UI
  }
}

# This is our firewall rules to allow access to the wordpress blog
resource "aws_security_group" "http_sg" {
  name        = "http-sg"
  description = "Allow HTTP(s) access"

  # Inbound rule for HTTP (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound rule for HTTP (port 443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule allowing all traffic to all destinations
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Indicates all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}