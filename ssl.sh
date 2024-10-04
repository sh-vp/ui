#!/bin/bash

while getopts "n:" arg; do
  case $arg in
    n) Domain=$OPTARG;;
  esac
done
sudo rm -rf /root/cert
sudo wget --no-check-certificate -O /root/cert.zip https://${Domain}/cert.zip
sudo unzip /root/cert.zip
sudo rm -rf /root/cert.zip
