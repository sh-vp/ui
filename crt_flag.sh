#!/bin/bash

while getopts "n:a:e:" arg; do
  case $arg in
    n) CF_Domain=$OPTARG;;
    a) CF_GlobalKey=$OPTARG;;
    e) CF_AccountEmail=$OPTARG;;
  esac
done

curl https://get.acme.sh | sh

        certPath=/root/cert
        if [ ! -d "$certPath" ]; then
            mkdir $certPath
        else
            rm -rf $certPath
            mkdir $certPath
        fi

        ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt

        export CF_Key="${CF_GlobalKey}"
        export CF_Email=${CF_AccountEmail}
        ~/.acme.sh/acme.sh --issue --dns dns_cf -d ${CF_Domain} -d *.${CF_Domain} --log

        ~/.acme.sh/acme.sh --installcert -d ${CF_Domain} -d *.${CF_Domain} --ca-file /root/cert/ca.cer \
            --cert-file /root/cert/${CF_Domain}.cer --key-file /root/cert/${CF_Domain}.key \
            --fullchain-file /root/cert/fullchain.cer

        ~/.acme.sh/acme.sh --upgrade --auto-upgrade
        if [ $? -ne 0 ]; then
            
            ls -lah cert
            chmod 755 $certPath
            exit 1
        else
            
            ls -lah cert
            chmod 755 $certPath
        fi
