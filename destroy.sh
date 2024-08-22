#!/bin/bash

check_aws_resources() {
  #Flag to track if any resources exist
  local resource_found=false

  # Check if the S3 bucket exists
  aws s3api head-bucket --bucket car-scraper-bucket 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "S3 bucket not found. Continuing..."
  else
    echo "S3 bucket found. Destroying..."
    resource_found=true
  fi

  # Check if the ECR repository exists
  aws ecr describe-repositories --repository-names car_scraper_lambda 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "ECR repository not found. Continuing..."
  else
    echo "ECR repository found. Destroying..."
    resource_found=true
  fi

  # Check if the Lambda function exists
  aws lambda get-function --function-name car_scraper 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "Lambda function not found. Continuing..."
  else
    echo "Lambda function found. Destroying..."
    resource_found=true
  fi

  # Check if the IAM role exists
  aws iam get-role --role-name lambda_role 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "IAM role not found. Continuing..."
  else
    echo "IAM role found. Destroying..."
    resource_found=true
  fi

  # Check if the IAM policy exists
  aws iam get-policy --policy-name dynamodb_lambda_policy 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "IAM policy not found. Continuing..."
  else
    echo "IAM policy found. Destroying..."
    resource_found=true
  fi

  # Check if the DynamoDB table exists
  aws dynamodb describe-table --table-name car_table 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "DynamoDB table not found. Continuing..."
  else
    echo "DynamoDB table found. Destroying..."
    resource_found=true
  fi

  if [ $resource_found = true ]; then
    return 0  # At least one resource found
  else
    return 1  # No resources found
  fi
}

delete_s3_bucket() {
  local region="$1"
  local bucket_name="car-scraper-bucket"

  echo "Deleting S3 bucket: $bucket_name"

  # Delete objects
  aws s3api delete-objects --bucket $bucket_name \
    --delete "$(aws s3api list-object-versions \
    --bucket $bucket_name \
    --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}')"

  # Delete markers
  aws s3api delete-objects --bucket $bucket_name \
    --delete "$(aws s3api list-object-versions \
    --bucket $bucket_name \
    --query='{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}')"

  # Delete bucket
  if aws s3 rb "s3://$bucket_name" --force; then
    echo "S3 bucket $bucket_name deleted successfully"
  else
    echo "Failed to delete S3 bucket $bucket_name. It might not exist or you do not have the necessary permissions."
  fi
}

cleanup() {
  aws_region="$1"

  check_aws_resources
    if [ $? -eq 1 ]; then
      echo "No AWS resources found. Exiting..."
      exit 0
    fi

  ( cd ./infras/lambda_infra && terraform init -reconfigure && terraform destroy -auto-approve )
  ( cd ./infras/repo_infra && terraform init -reconfigure && terraform destroy -auto-approve )

  delete_s3_bucket "$aws_region"
}

cleanup $1
