#!/bin/bash

# Create S3 bucket for Terraform state
create_s3_bucket() {
  local aws_region="$1"
  local bucket_name="$2"

  if aws s3api head-bucket --bucket "$bucket_name" 2>/dev/null; then
    echo "S3 bucket $bucket_name already exists."
  else
    echo "Creating S3 bucket: $bucket_name"
    aws s3api create-bucket --bucket $bucket_name --region $aws_region --create-bucket-configuration LocationConstraint=$aws_region
    aws s3api put-bucket-versioning --bucket $bucket_name --versioning-configuration Status=Enabled
    aws s3api put-bucket-encryption --bucket $bucket_name --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
    echo "S3 bucket created successfully."
  fi
}

# Init and apply Terraform for repo infrastructure
create_repo_infrastructure() {
  local aws_region="$1"
  local bucket_name="$2"
    
  ( cd ./infras/repo_infra && terraform init -backend-config="bucket=$bucket_name" -backend-config="region=$aws_region" && terraform apply -auto-approve )
  if [ $? -ne 0 ]; then
    echo "Terraform apply for repo_infra failed. Exiting."
    exit 1
  fi
}

# Build and tag Docker image
image_builder() {
  local aws_region="$1"
  local aws_account_id="$2"
  local image_name="$3"
  local image_tag="$4"

  docker build -t ${image_name}:${image_tag} ./scraper

  if [ $? -ne 0 ]; then
    echo "Docker build failed. Exiting."
    exit 1
  fi

  docker tag ${image_name}:${image_tag} ${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com/${image_name}:${image_tag}
}

# Login and push Docker image to ECR
image_uploader() {
  local aws_region="$1"
  local aws_account_id="$2"
  local image_name="$3"
  local image_tag="$4"

  # Login to ECR
  aws ecr get-login-password --region ${aws_region} | docker login --username AWS --password-stdin ${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com

  if [ $? -ne 0 ]; then
    echo "ECR login failed. Exiting."
    exit 1
  fi

  # Push image to ECR
  docker push ${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com/${image_name}:${image_tag}
  if [ $? -ne 0 ]; then
    echo "Docker push failed. Exiting."
    exit 1
  fi
}

# Init and apply Terraform for Lambda infrastructure
create_lambda_infrastructure() {
  local aws_region="$1"
  local bucket_name="$2"
    
  ( cd ./infras/lambda_infra && terraform init -backend-config="bucket=$bucket_name" -backend-config="region=$aws_region" && terraform apply -auto-approve -var "scrape_url=$SCRAPE_URL" )
  if [ $? -ne 0 ]; then
    echo "Terraform apply for lambda_infra failed. Exiting."
    exit 1
  fi
}

deploy() {
  aws_region="$1"
  aws_account_id="$2"
  aws_bucket_name="car-scraper-bucket"

  image_name=car_scraper_lambda
  image_tag=latest

  create_s3_bucket "$aws_region" "$aws_bucket_name"
  create_repo_infrastructure "$aws_region" "$aws_bucket_name"
  image_builder "$aws_region" "$aws_account_id" "$image_name" "$image_tag"
  image_uploader "$aws_region" "$aws_account_id" "$image_name" "$image_tag"
  create_lambda_infrastructure "$aws_region" "$aws_bucket_name"
}

deploy "$1" "$2"
