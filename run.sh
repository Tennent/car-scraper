#!/bin/bash

run_lambda() {
    aws_region="$1"
    aws_account_id="$2"

    aws lambda get-function --function-name car_scraper > /dev/null

    if [ $? -ne 0 ]; then
        echo "Lambda function not found. Creating..."
        ./deploy.sh "$aws_region" "$aws_account_id"
    else
        echo "Lambda function found. Invoking..."
        aws lambda invoke --function-name car_scraper response.json
    fi
}

run_lambda "$1" "$2"
