#!/bin/bash
run_lambda() {
  aws lambda get-function --function-name car_scraper > /dev/null

  if [ $? -ne 0 ]; then
    echo "Lambda function not found. Exiting..."
      exit 1
  else
    echo "Lambda function found. Invoking..."
    aws lambda invoke --function-name car_scraper response.json
  fi
}

run_lambda
