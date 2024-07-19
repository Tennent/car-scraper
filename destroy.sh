#!/bin/bash

cleanup() {
    aws_region="$1"
    aws_account_id="$2"

    ( cd ./infras/lambda_infra && terraform destroy -auto-approve )
    ( cd ./infras/repo_infra && terraform destroy -auto-approve )
}

cleanup $1 $2
