#!/bin/bash
domain=$1
apt update -y && apt upgrade -y
apt install php -y
sudo apt install nginx certbot python3-certbot-nginx php php-curl -y
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/${domain}
ln -s /etc/nginx/sites-available/${domain} /etc/nginx/sites-enabled/
cd /etc/nginx/sites-enabled && ls -la
sed -i -e "s/server_name _/server_name ${domain}/g" /etc/nginx/sites-available/${domain}
root="/var/www/html"
root2="/root"
sed -i -e "s/$root/$root2/g" /etc/nginx/sites-available/${domain} 
systemctl stop apache2
systemctl disable apache2
systemctl mask apache2
systemctl restart nginx
certbot --nginx -d ${domain} --register-unsafely-without-email
v=php -v | grep -Po '(?<=PHP )([0-9].[0-9])'
sudo apt-get install php$v-ssh2 -y
