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
    region = "eu-north-1"
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_ecr_repository" "car_scraper_lambda" {
  name                 = "car_scraper_lambda"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.car_scraper_lambda.repository_url
}
