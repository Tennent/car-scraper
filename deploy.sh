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
    
    ( cd ./infras/repo_infra && terraform init -backend-config="bucket=car-scraper-repo-bucket" -backend-config="region=$aws_region" && terraform apply -auto-approve )
    if [ $? -ne 0 ]; then
        echo "Terraform apply for repo_infra failed. Exiting."
        exit 1
    fi
}

deploy() {
    aws_region="$1"
    aws_account_id="$2"
    aws_bucket_name="car-scraper-repo-bucket"

    image_name=car_scraper_lambda
    image_tag=latest

    # Create S3 bucket for Terraform state
    create_s3_bucket "$aws_region" "aws_bucket_name"
}

deploy "$1" "$2"
