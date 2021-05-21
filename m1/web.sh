#!/bin/bash

echo "* Add hosts ..."
echo "192.168.89.100 web.dob.lab web" >> /etc/hosts
echo "192.168.89.101 db.dob.lab db" >> /etc/hosts

echo "* Install Software ..."
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y apache2 php php-mysqlnd git

echo "* Start HTTP ..."
sudo systemctl enable apache2.service
sudo systemctl start apache2.service

echo "* Firewall - open port 80 ..."
echo 'y' | sudo ufw enable
sudo ufw allow 80/tcp comment 'accept Apache'
sudo ufw allow 443/tcp comment 'accept HTTPS connections'
sudo ufw allow ssh comment 'accept SSH'
sudo ufw reload

echo "* Cloning frontend ..."
cd
sudo git clone https://github.com/VasAtanasov/dob-module-1

echo "Clean up /var/www/html/ ..."
sudo rm -rfv /var/www/html/*

echo "* Copy web site files to /var/www/html/ ..."
sudo cp dob-module-1/web/* /var/www/html
ls -alh /var/www/html

echo "* Editing config file"
sudo sed -i -e 's/$database = "".*/$database = "bulgaria";/' /var/www/html/config.php
sudo sed -i -e 's/$user = "".*/$user = "web_user";/' /var/www/html/config.php
sudo sed -i -e 's/$password  = "".*/$password = "Password1";/' /var/www/html/config.php
sudo sed -i -e 's/$host = "".*/$host = "db";/' /var/www/html/config.php
