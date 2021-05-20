#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

# install requirements

echo "       __                    _ _____       "
echo "__  __ \ \ _   _  __ _  __ _| |___ / _ __  "
echo "\ \/ /  \ \ | | |/ _` \/ _` | | |_ \| '__| "
echo " >  </\_/ / |_| | (_| | (_| | |___) | |    "
echo "/_/\_\___/ \__,_|\__, |\__, |_|____/|_|    "
echo "                 |___/ |___/               "

sudo apt-get update
sudo apt-get install python3-dev --yes
sudo apt-get install libmysqlclient-dev --yes
sudo apt-get install unzip --yes
sudo apt-get install libpq-dev python-dev libxml2-dev libxslt1-dev libldap2-dev --yes
sudo apt-get install libsasl2-dev libffi-dev --yes
curl -O https://bootstrap.pypa.io/get-pip.py ; python3 get-pip.py --user
sudo rm get-pip.py
sudo apt-get install mysql-client --yes

export PATH=$PATH:/home/ubuntu/.local/bin/

pip3 install flask
pip3 install wtforms
pip3 install flask_mysqldb
pip3 install passlib

sudo apt install awscli --yes
sudo mkdir ~/.aws || sudo cp /tmp/credentials ~/.aws/credentials || sudo cp /tmp/config ~/.aws/config
sudo rm /tmp/credentials /tmp/config

# Download data for migration 
aws s3 cp s3://bootcamp-aws/dump.sql
aws s3 cp s3://bootcamp-aws/wikiapp.zip .

# Get RDS Endpoint to connect and create mySQL DB
aws rds describe-db-instances > /tmp/endpoint.json
sudo touch /tmp/endpoint.txt
rds==$(sudo cut -b 29-105 /tmp/endpoint.txt)

dbpass=$(</tmp/dbpass)
sudo rm /tmp/dbpass

# Login to mySQL
mysql -h $rds -P 3306 -u admin -p $dbpass

#TODO
# Create
create database wikidb;
use wikidb;
source dump.sql;
CREATE USER wiki@'%' IDENTIFIED BY 'admin123456';
GRANT ALL PRIVILEGES ON wikidb.* TO wiki@'%';
FLUSH PRIVILEGES;
exit

sudo unzip wikiapp.zip


