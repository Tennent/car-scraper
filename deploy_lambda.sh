#!/bin/bash

# Init and apply Terraform for Lambda infrastructure
create_lambda_infrastructure() {
    local aws_region="$1"
    local bucket_name="$2"
    
    ( cd ./infras/lambda_infra && terraform init -backend-config="bucket=$bucket_name" -backend-config="region=$aws_region" && terraform apply -auto-approve -var "scrape_url=$SCRAPE_URL" -var "aws_region=$aws_region" )
    if [ $? -ne 0 ]; then
        echo "Terraform apply for lambda_infra failed. Exiting."
        exit 1
    fi
}

deploy_lambda() {
    aws_region="$1"
    aws_bucket_name="car-scraper-bucket"

    create_lambda_infrastructure "$aws_region" "$aws_bucket_name"
}

deploy_lambda "$1"
