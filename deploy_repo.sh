#!/bin/bash

# Init and apply Terraform for repo infrastructure
create_repo_infrastructure() {
    local aws_region="$1"
    local bucket_name="$2"
    
    ( cd ./infras/repo_infra && terraform init -backend-config="bucket=$bucket_name" -backend-config="region=$aws_region" && terraform apply -auto-approve -var "aws_region=$aws_region" )
    if [ $? -ne 0 ]; then
        echo "Terraform apply for repo_infra failed. Exiting."
        exit 1
    fi
}

deploy_repo() {
    aws_region="$1"
    aws_bucket_name="car-scraper-bucket"

    create_repo_infrastructure "$aws_region" "$aws_bucket_name"
}

deploy_repo "$1"
