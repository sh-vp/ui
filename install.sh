#!/bin/bash

red='\033[1;91m'          # Red
green='\033[1;92m'        # Green
White='\033[1;97m'        # White

read -p "Please Enter Your Telegram Bot Domain :" domain
echo -e  "Your Telegram Bot Domain Will Set to : ${red}${domain}${White}"
read -p "Please Enter Your Telegram Bot Token :" token
echo -e  "Your Telegram Bot Token will set to : ${red}${token}${White}"
apt update -y && apt upgrade -y
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
wget --no-check-certificate -O /root/code.zip https://raw.githubusercontent.com/sh-vp/ui/main/code.zip
unzip -o /root/code.zip -d /root
curl -X POST https://api.telegram.org/bot${token}/setWebhook?url=${domain}/index.php -H "Accept: application/json" -H "Content-Type: text/html" -H "Content-Length: 0"
clear
echo -e  "${red}-------------------------------------------${White}"
echo -e  "Script Installation ${green}Successfully ${White}Finished !"
echo -e  "${red}-------------------------------------------${White}"
