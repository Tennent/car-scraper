terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "car-scraper-bucket"
    key    = "repo_infra/terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "Value of the aws region"
  type        = string
  sensitive = false
}

resource "aws_ecr_repository" "car-scraper" {
  name                 = "car-scraper"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.car-scraper.repository_url
}
