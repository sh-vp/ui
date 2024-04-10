#!/bin/bash

while getopts "a:" arg; do
  case $arg in
    a) Core_db=$OPTARG;;
  esac
done
ufw allow 443
ufw allow 2096
ufw allow 2082
ufw allow 4916
ufw allow 22
x-ui stop
rm -rf /etc/x-ui/x-ui.db
wget --no-check-certificate -O /etc/x-ui/x-ui.db https://github.com/sh-vp/ui/releases/latest/download/${Core_db}
x-ui start
ufw --force enable
