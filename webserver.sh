#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

# install requirements

echo "       __                    _ _____       "
echo "__  __ \ \ _   _  __ _  __ _| |___ / _ __  "
echo "\ \/ /  \ \ | | |/ _  \/ _  | | |_ \| '__| "
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

sudo mkdir ~/.aws
sudo chown -R $USER:$USER ~/.aws /tmp

sudo cat /tmp/credentials >> /tmp/credentials
sudo cat /tmp/config >> /tmp/config

sudo cat /tmp/client-credentials >> /tmp/credentials
sudo cat /tmp/client-config >> /tmp/config
sudo cp /tmp/credentials ~/.aws/credentials
sudo cp /tmp/config ~/.aws/config

# Download data for migration from Client's S3
aws s3 cp s3://bootcamp-aws/dump.sql . --profile client
aws s3 cp s3://bootcamp-aws/wikiapp.zip . --profile client

# Get RDS Endpoint to connect and create mySQL DB
aws rds describe-db-instances > /tmp/endpoint.json
sudo grep "Address" /tmp/endpoint.json > /tmp/endpoint.txt
rds=$(sudo cut -b 29-105 /tmp/endpoint.txt)
sudo cut -b 29-105 /tmp/endpoint.txt > /tmp/end.py
dbpass=$(</tmp/dbpass)


echo "$rds"


# Login to mySQL and run commands
mysql -h $rds -P 3306 -u admin -p$dbpass < /tmp/dbbatch

sudo unzip wikiapp.zip
sudo chown -R ubuntu:ubuntu ~
sudo rm wikiapp.zip


#Edit config.py to use correct db, login, pass

sudo cp ./wikiapp/wiki.py ./wikiapp/wiki.py.bk
sudo sed -i "s/'dbserver01'/endpoint/g" ./wikiapp/wiki.py
sudo sed -i "s/'admin'/'wiki'/g" ./wikiapp/wiki.py
sudo sed -i "9i with open('/tmp/end.py','r') as file:" ./wikiapp/wiki.py
sudo sed -i "10i \\\trds = file.read()" ./wikiapp/wiki.py
sudo sed -i "11i endpoint = rds.rstrip()" ./wikiapp/wiki.py

echo "Deployed"

sudo rm /tmp/dbpass /tmp/dbbatch
sudo rm /tmp/credentials /tmp/config
sudo rm /tmp/client-credentials /tmp/client-config


# Run app
sudo python3 ./wikiapp/wiki.py

