#!/bin/bash

run_lambda() {
    aws lambda invoke --function-name car_scraper response.json 
}

run_lambda
