# Minimal HCP Terraform Configuration
# This is the template for self-service infrastructure provisioning

terraform {
  required_version = ">= 1.14"
  
  cloud {
    organization = "YOUR_ORG_NAME"
    
    workspaces {
      name = "YOUR_WORKSPACE_NAME"
    }
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Variables
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "Project identifier"
  type        = string
}

resource "aws_s3_bucket" "example" {
  bucket = "${var.project_name}-${var.environment}-data"
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

output "bucket_name" {
  value = aws_s3_bucket.example.id
}
