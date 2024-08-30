<a id="readme-top"></a>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/Tennent/car-scraper">
    <img src="images/logo.png" alt="Logo" width="250" height="250">
  </a>
</div>

<h3 align="center">Car Scraper Project</h3>


<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About The Project

This web scraper application is designed to collect model and price data and store it in a database. The project is a demonstration of my skills in DevOps and infrastructure management, with a focus on automation and reliability.

Key Features:

  - **Data Collection:** The scraper extracts model and pricing information from the target website.
  - **Database Integration:** Collected data is stored in a database, organized for easy access.
  - **Automation:** The entire process is automated, from data extraction to database storage, reducing manual intervention and ensuring continuous operation.
  - **Infrastructure as Code:** The project leverages infrastructure as code (IaC) principles to manage deployment, ensuring consistent and reproducible environments.
  - **DevOps Best Practices:** The project follows DevOps best practices, including CI/CD pipelines, automated testing, and containerization, ensuring smooth development and deployment processes.

This project serves as a practical showcase of my ability to design, implement, and manage infrastructure systems, highlighting my proficiency in both software development and DevOps methodologies.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


### Built With

* [![Shell][Shell]][Shell-url]
* [![Python][Python]][Python-url]
* [![Docker][Docker]][Docker-url]
* [![Terraform][Terraform]][Terraform-url]
* [![GitHubActions][GitHubActions]][GitHubActions-url]
* [![AWS][AWS]][AWS-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started

To get your on deployment up and running follow these simple steps.

### Prerequisites

* AWS Account - [Register Here](https://signin.aws.amazon.com/signup?request_type=register)
* AWS Access Key - [Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
* Docker Hub Account - [Register Here](https://app.docker.com/signup)
* Docker Personal Access Token - [Guide](https://docs.docker.com/security/for-developers/access-tokens/)
  

### Installation

0. Set up the following repository secrets for you workflow

  * AWS_ACCOUNT_ID - [Find it here](https://repost.aws/questions/QUz8hTa39ZRAKk4yodHkDL9w/where-can-i-find-my-aws-account-id)
  * AWS_ACCESS_KEY_ID - Generated in the 'Prerequisites' section
  * AWS_SECRET_ACCESS_KEY - Generated in the 'Prerequisites' section
  * AWS_REGION - The region you prefer to use for AWS deployment (e.g.: eu-north-1)
  * DOCKERHUB_USERNAME - The Docker Hub username you signed up with
  * DOCKERHUB_TOKEN - Generated in the 'Prerequisites' section
  * SCRAPE_URL - The URL to scrape (in this case its set up tp work with https://auto.suzuki.hu/modellek only)

1. Select the Settings tab in the GitHub repo

   <img src="images/settings-tab.png" alt="settings-tab" width="800" height="91">

2. Select Actions within Secrets and variables from the Security section on the left

   <img src="images/action-secrets.png" alt="action-secrets" width="350" height="265">

3. Click the New repository secret button

   <img src="images/new-secret.png" alt="new-secret" width="650" height="390">

4. Fill in the secret name and value, then click Add secret

   <img src="images/secret-value.png" alt="secret-value" width="650" height="340">


<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

Follow thse steps to run the workflow and view the finsihed output.

1. Select the Actions tab in the GitHub repo

   <img src="images/actions-tab.png" alt="actions-tab" width="800" height="91">

2. Select the CI workflow from the lost on the left

   <img src="images/ci-workflow.png" alt="ci-workflow" width="350" height="458">

3. Click the dropdown menu for Run workflow and select the branch to run the workflow on (it should always be main)

   <img src="images/run-workflow.png" alt="run-workflow" width="350" height="212">

4. Wait for the CI and CD workflows to finish

   <img src="images/finished-workflow-runs.png" alt="finished-workflow-runs" width="850" height="113">

5. Search for DynamoDB in the AWS Management Console

   <img src="images/aws-console-search.png" alt="aws-console-search" width="650" height="350">

6. View the database content

   <img src="images/dynamodb-content.png" alt="dynamodb-content" width="850" height="362">

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- CONTACT -->
## Contact

Zalán Márton - [LinkedIn](https://www.linkedin.com/in/zalan-marton/) - zalan.marton@gmail.com

Project Link: [https://github.com/Tennent/car-scraper](https://github.com/Tennent/car-scraper)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[Shell]: https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white
[Shell-url]: https://www.gnu.org/software/bash/
[Python]: https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54
[Python-url]: https://www.python.org/
[Docker]: https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white
[Docker-url]: https://www.docker.com/
[Terraform]: https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white
[Terraform-url]: https://www.terraform.io/
[AWS]: https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white
[AWS-url]: https://aws.amazon.com/
[GitHubActions]: https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white
[GitHubActions-url]: https://github.com/features/actions
