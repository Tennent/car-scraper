#!/bin/bash

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

    ( cd ./infras/lambda_infra && terraform destroy -auto-approve )
    ( cd ./infras/repo_infra && terraform destroy -auto-approve )

    delete_s3_bucket "$aws_region"
}

cleanup $1
