#!/bin/bash
echo "Copying certs to /etc/ssl/certs/ ...."
sudo mv /tmp/etc/ssl/certs/*.* /etc/ssl/certs/
sudo chown  root:root -R /etc/ssl/certs/
sudo chmod  777 -R /etc/ssl/certs/
echo "Copying nginx keys to /etc/ssl/ ...."
sudo mv /tmp/etc/ssl/nginx /etc/ssl/
sudo chown  root:root -R /etc/ssl/nginx/
sudo chmod  777 -R /etc/ssl/nginx/

sudo wget https://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
sudo apt-get -y install apt-transport-https lsb-release ca-certificates
printf "deb https://plus-pkgs.nginx.com/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
sudo wget -q -O /etc/apt/apt.conf.d/90nginx https://cs.nginx.com/static/files/90nginx
sudo apt-get -y update
sudo apt-get install -y nginx-plus
sudo apt-get install -y nginx-plus-module-njs
sudo apt-get install -y nginx-plus-module-opentracing
sudo apt-get install -y nginx-plus-module-headers-more

echo "Making nginx backup ...."
sudo mv /etc/nginx /tmp/etc/nginx-backup
sudo mv /tmp/etc/nginx /etc/
sudo ln -s /usr/lib/nginx/modules /etc/nginx/modules
sudo chown  root:root -R /etc/nginx/
sudo chmod  777 -R /etc/nginx/
sudo nginx -t -c /etc/nginx/nginx.conf
sudo service nginx restart
