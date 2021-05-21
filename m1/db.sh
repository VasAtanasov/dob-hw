#!/bin/bash

echo "* Add hosts ..."
echo "192.168.89.100 web.dob.lab web" >> /etc/hosts
echo "192.168.89.101 db.dob.lab db" >> /etc/hosts

echo "* Install Software ..."
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y mariadb-server

echo "* Start MariaDB ..."
sudo systemctl enable mariadb
sudo systemctl start mariadb

echo "Updating mariadb configs in /etc/mysql/mariadb.conf.d/50-server.cnf"
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
echo "Updated mariadb bind address in /etc/mysql/mariadb.conf.d/50-server.cnf to 0.0.0.0 to allow external connections."

echo "Restarting mariadb ..."
sudo systemctl restart mariadb

echo "* Firewall - open port 3306 ..."
echo 'y' | sudo ufw enable
sudo ufw allow 3306/tcp comment 'accept Database connections'
sudo ufw allow ssh comment 'accetp SSH'
sudo ufw reload

echo "* Cloning backend ..."
cd
sudo git clone https://github.com/VasAtanasov/dob-module-1

echo "* Create and load the database ..."
sudo mysql -u root < dob-module-1/db/db_setup.sql
