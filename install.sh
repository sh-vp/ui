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
sudo apt install nginx certbot python3-certbot-nginx php php-curl zip ufw -y
sudo apt remove apache2 -y
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/${domain}
ln -s /etc/nginx/sites-available/${domain} /etc/nginx/sites-enabled/
cd /etc/nginx/sites-enabled && ls -la
sed -i -e "s/server_name _/server_name ${domain}/g" /etc/nginx/sites-available/${domain}
sed -i -e "s/80 default_server/80/g" /etc/nginx/sites-available/${domain} 
sed -i -e "s|# server_names_hash_bucket_size 64| server_names_hash_bucket_size 512|g" /etc/nginx/sites-available/${domain} 
systemctl enable nginx
systemctl restart nginx
certbot --nginx -d ${domain} --register-unsafely-without-email
v=php -v | grep -Po '(?<=PHP )([0-9].[0-9])'
sudo apt-get install php$v-ssh2 -y
wget --no-check-certificate -O /root/code.zip https://github.com/sh-vp/ui/releases/latest/download/code.zip
unzip -o /root/code.zip -d /var/www/html/
rm-rf /root/code.zip
chmode +x /var/www/html/cert.sh
ln -s /var/www/html/index.php /root/
ln -s /var/www/html/config.php /root/
ln -s /var/www/html/servers.txt /root/
ufw allow http
ufw allow https
ufw allow 22
ufw enable
curl -X POST https://api.telegram.org/bot${token}/setWebhook?url=${domain}/index.php -H "Accept: application/json" -H "Content-Type: text/html" -H "Content-Length: 0"
clear
echo -e  "${red}-------------------------------------------${White}"
echo -e  "Script Installation ${green}Successfully ${White}Finished !"
echo -e  "${red}-------------------------------------------${White}"
echo -e  "Use ${green}php index.php${White} Code to run script"

