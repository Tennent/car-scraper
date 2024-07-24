terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "car-scraper-bucket"
    key    = "lambda_infra/terraform.tfstate"
    region = "eu-north-1"
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_iam_policy" "dynamodb_lambda_policy" {
  name = "dynamodb_lambda_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem"
        ]
        Resource = [
          aws_dynamodb_table.car_table.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.dynamodb_lambda_policy.arn
}

data "terraform_remote_state" "repo_infra" {
  backend = "s3"
  config = {
    bucket = "car-scraper-bucket"
    key    = "repo_infra/terraform.tfstate"
    region = "eu-north-1"
  }
}

resource "aws_lambda_function" "car_scraper_lambda" {
  function_name = "car_scraper"
  image_uri     = "${data.terraform_remote_state.repo_infra.outputs.ecr_repository_url}:latest"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"

  runtime = "python3.8"
}

resource "aws_dynamodb_table" "car_table" {
  name           = "car_table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "model_name"

  attribute {
    name = "model_name"
    type = "S"
  }

  attribute {
    name = "model_price"
    type = "N"
  }

  global_secondary_index {
    name               = "price_index"
    hash_key           = "model_price"
    projection_type    = "ALL"
  }

  tags = {
    Name = "car_table"
  }
}
