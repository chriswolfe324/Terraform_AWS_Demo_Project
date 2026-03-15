#!/bin/bash


yum update -y
yum install -y git

# Install NodeJS 18
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

cd /home/ec2-user

# Clone application
git clone https://github.com/chriswolfe324/Terraform_AWS_Demo_Project.git

cd Terraform_AWS_Demo_Project/

npm install
node app.js