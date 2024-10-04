#!/bin/bash

while getopts "a:" arg; do
  case $arg in
    a) Core_db=$OPTARG;;
  esac
done
sudo ufw allow 443
sudo ufw allow 2096
sudo ufw allow 2082
sudo ufw allow 4916
sudo ufw allow 22
sudo x-ui stop
sudo rm -rf /etc/x-ui/x-ui.db
sudo wget --no-check-certificate -O /etc/x-ui/x-ui.db https://github.com/sh-vp/ui/releases/latest/download/${Core_db}
sudo x-ui start
sudo ufw --force enable
