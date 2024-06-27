# Project Overview - Car Web Scraper

## Project Parts

  - **Python-based Web Scraper**
     
    - Rate Limiting and Throttling*: Avoid getting blocked by the website while scraping.
    - Data Validation: Data is validated and cleaned before storing in database.

  - **Database for Storing Scraped Data**
 
    - Postgres or DynamoDB
    - Database Schema
    - Connection Management: Handling of database connections in a serverless environment (Lambda).

  - **Cloud Computing with AWS Lambda**
       
    - Terraform to define cloud infrastructure.
    - AWS Lambda: Running scraping script at scheduled intervals using AWS CloudWatch Events.
    - API Gateway: Endpoint for the refresh button, which triggers the Lambda function.
    - AWS IAM: Appropriate IAM roles and policies.

  - **CI/CD Pipeline**
        
    - Version Control: Git and GitHub for code repository.
    - CI/CD Tool: GitHub Actions.
    - Testing: Unit tests for the scraper and integration tests for the entire setup.
    - Deployment: Automate the deployment of the Lambda function and database schema changes.
    - Linting and Code Quality: pylint to maintain code quality.


## Tech Stack

  - Web Scraper: Python, BeautifulSoup/Scrapy/Selenium
  - Database: PostgreSQL or DynamoDB
  - Cloud Computing: AWS Lambda, AWS API Gateway, AWS CloudWatch
  - CI/CD: GitHub Actions
  - IaC: Terraform 
  - Testing: pytest for unit and integration tests


## Example Workflow

  - Code Development: Develop the web scraper and database schema locally.
  
  - Version Control: Push code to a Git repository.
  
  - CI Pipeline:
    - Run linting scan.
    - Run unit and integration tests.
    - If tests pass, package the Lambda function and deploy it using Terraform.
    
  - Cloud Deployment:
    - Deploy the Lambda function and API Gateway.
    - Schedule Lambda executions using CloudWatch Events.
