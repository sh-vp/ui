#!/bin/bash
red='\033[1;91m'          # Red
green='\033[1;92m'        # Green
White='\033[1;97m'        # White
yellow='\033[1;93m'       # Yellow
clear
echo -e  "-------------------------------------------"
echo -e  ""
echo -e  "-------------${green} Input Data Set ${White}--------------"
echo -e  ""
echo -e  "-------------------------------------------"
read -p "Please Enter Your Telegram Bot Domain :" domain
echo -e  ""
echo -e  "Your Telegram Bot Domain Will Set to : ${green}${domain}${White}"
echo -e  ""
read -p "Please Enter Your Telegram Bot Token :" token
echo -e  ""
echo -e  "Your Telegram Bot Token will set to : ${green}${token}${White}"
echo -e  ""
echo -e  "${yellow}Start installing Script ...${White}"
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
wget --no-check-certificate -O /root/code.zip https://github.com/sh-vp/ui/releases/latest/download//code.zip
unzip -o /root/code.zip -d /root
clear
curl -X POST https://api.telegram.org/bot${token}/setWebhook?url=${domain}/index.php -H "Accept: application/json" -H "Content-Type: text/html" -H "Content-Length: 0"
#clear
echo -e  "${red}-------------------------------------------${White}"
echo -e  "Script Installation ${green}Successfully ${White}Finished !"
echo -e  "${red}-------------------------------------------${White}"
echo -e  "Use ${green}php index.php${White} Code to run script"

