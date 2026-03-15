#!/bin/bash

yum update -y
yum install -y git

# Install NodeJS 18
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs
npm install -g pm2

cd /home/ec2-user

# Clone application
git clone https://github.com/chriswolfe324/Book_Database_AWS.git
cd Book_Database_AWS/

export PGHOST="${db_endpoint}"
export PGUSER="${db_username}"
export PGPASSWORD="${db_password}"
export PGDATABASE="${db_name}"
export PGPORT="5432"

npm install

pm2 start app.js --name book-app
pm2 save