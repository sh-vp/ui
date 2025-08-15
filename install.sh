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
read -p "Please Enter Your Telegram Bot Token :" token
echo -e  ""
echo -e  "Your Telegram Bot Token will set to : ${green}${token}${White}"
echo -e  ""
read -p "Please Enter Your Telegram chat_id :" chatid
echo -e  ""
echo -e  "Your Telegram chat_id will set to : ${green}${chatid}${White}"
echo -e  ""
read -p "Please Enter Your license key code:" keycode
echo -e  ""
echo -e  "Your license key code will set to : ${green}${keycode}${White}"
echo -e  ""
echo -e  "${yellow}Start installing Script ...${White}"
apt update -y -q && apt upgrade -y -q
sudo apt install nginx certbot python3-certbot-nginx php php-curl php-fpm zip ufw -y -q
sudo apt remove apache2 -y
sudo systemctl enable nginx
sudo systemctl restart nginx
v=php -v | grep -Po '(?<=PHP )([0-9].[0-9])'
sudo apt-get install php$v-ssh2 -y
rm -rf /var/www/html/index*
wget --no-check-certificate -O /var/www/html/code.zip https://github.com/sh-vp/ui/releases/latest/download/code.zip
unzip -o /var/www/html/code.zip -d /var/www/html/
rm -rf /var/www/html/code.zip
chmod +x /var/www/html/cert.sh
ln -s /var/www/html/config.php /root/
ln -s /var/www/html/servers.txt /root/
ufw allow http
ufw allow https
ufw allow 22
ufw --force enable
cat <<\EOF > /var/www/html/set_base.php
<?php
$key_code = "keyx";
$server_ip = "ipx";
$tg_token = "tx";
$admin = "cx";
EOF
sip=$(ip -4 addr show eth0 | grep -m 1 -oP '(?<=inet\s)\d+(\.\d+){3}')
sed -i -e 's/keyx/'${keycode}'/g' /var/www/html/set_base.php
sed -i "s/ipx/$sip/g" /var/www/html/set_base.php
sed -i -e 's/tx/'${token}'/g' /var/www/html/set_base.php
sed -i -e 's/cx/'${chatid}'/g' /var/www/html/set_base.php
clear
echo -e  "${red}-------------------------------------------${White}"
echo -e  "Script Installation ${green}Successfully ${White}Finished !"
echo -e  "${red}-------------------------------------------${White}"
echo -e  "For Use Script First go to ${green}/var/www/html${White} With ${green}cd /var/www/html${White}"
echo -e  "Then use ${green}php index.php ${White} For runing the script"
