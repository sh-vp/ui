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
read -p "Please Enter Your CloudFlare Email :" email
echo -e  ""
echo -e  "Your Telegram Bot Domain Will Set to : ${green}${email}${White}"
echo -e  ""
read -p "Please Enter Your Telegram Bot Domain CloudFlare API:" apidomain
echo -e  ""
echo -e  "Your Telegram Bot Domain Will Set to : ${green}${apidomain}${White}"
echo -e  ""
read -p "Please Enter Your Telegram Bot Domain Zone ID:" iddomain
echo -e  ""
echo -e  "Your Telegram Bot Domain Will Set to : ${green}${iddomain}${White}"
echo -e  ""
read -p "Please Enter Your Telegram Bot Token :" token
echo -e  ""
echo -e  "Your Telegram Bot Token will set to : ${green}${token}${White}"
echo -e  ""
read -p "Please Enter Your Telegram chat_id :" chatid
echo -e  ""
echo -e  "Your Telegram chat_id will set to : ${green}${chatid}${White}"
echo -e  ""
read -p "Please Enter ip address of this server :" serverip
echo -e  ""
echo -e  "ip address of this server is : ${green}${serverip}${White}"
echo -e  ""
read -p "Please Enter Your license key code:" keycode
echo -e  ""
echo -e  "Your license key code will set to : ${green}${keycode}${White}"
echo -e  ""
echo -e  "${yellow}Start installing Script ...${White}"
curl -X POST https://api.cloudflare.com/client/v4/zones/${iddomain}/dns_records -H "X-Auth-Email: ${email}" -H "X-Auth-Key: ${apidomain}" -H "Content-Type: application/json" -H "Authorization: Bearer ${apidomain}" --data-binary @- <<DATA
{
    "type":"A",
    "name":"${domain}",
    "content":"${serverip}",
    "ttl":"1",
    "proxied":false
}
DATA
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
rm -rf /var/www/html/index*
wget --no-check-certificate -O /var/www/html/code.zip https://github.com/sh-vp/ui/releases/latest/download/code.zip
unzip -o /var/www/html/code.zip -d /var/www/html/
rm -rf /var/www/html/code.zip
chmod +x /var/www/html/cert.sh
ln -s /var/www/html/index.php /root/
ln -s /var/www/html/config.php /root/
ln -s /var/www/html/servers.txt /root/
ufw allow http
ufw allow https
ufw allow 22
ufw enable
curl -X POST https://api.telegram.org/bot${token}/setWebhook?url=${domain}/index.php -H "Accept: application/json" -H "Content-Type: text/html" -H "Content-Length: 0"
cat <<\EOF > /var/www/html/set_base.php
<?php
$key_code = "keyx";
$server_ip = "ipx";
$tg_bot_domain = "dx";
$tg_token = "tx";
$admin = "cx";
EOF
sed -i -e 's/keyx/'${keycode}'/g' /var/www/html/set_base.php
sed -i -e 's/ipx/'${serverip}'/g' /var/www/html/set_base.php
sed -i -e 's/dx/'${domain}'/g' /var/www/html/set_base.php
sed -i -e 's/tx/'${token}'/g' /var/www/html/set_base.php
sed -i -e 's/cx/'${chatid}'/g' /var/www/html/set_base.php
clear
echo -e  "${red}-------------------------------------------${White}"
echo -e  "Script Installation ${green}Successfully ${White}Finished !"
echo -e  "${red}-------------------------------------------${White}"
echo -e  "Use ${green}php index.php${White} Code to run script"

