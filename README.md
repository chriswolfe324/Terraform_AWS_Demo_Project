AWS Terraform Portfolio Project



1. Overview

This is a production-style project that launches an application for keeping track of books that have been read. This project was built in order to demo my knowledge of AWS resources and Infrastructure as Code. 

2. Architecture

3. Tech Stack
  * AWS (ALB, EC2, IAM, RDS, S3, Lambda, Fargate, ECS)
  * Terraform

4. How It Works
  1. User accesses the book database through the Application Load Balancer in a public subnet
  2. The Application Load Balancer routes traffic to EC2 instances that are located in private subnets
  3. Book information is saved in AWS RDS database
  4. When user clicks "Generate Report", that starts a Lambda function which triggers ECS containers to generate the report
  5. The report is stored in an S3 bucket and the application gives the user a download link to the report.

5. Deployment

6. Planned Improvements
