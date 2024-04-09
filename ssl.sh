#!/bin/bash

while getopts "n:" arg; do
  case $arg in
    n) Domain=$OPTARG;;
  esac
done
rm -rf /root/cert
wget --no-check-certificate -O /root/cert.zip https://${Domain}/cert.zip
unzip /root/cert.zip
rm -rf /root/cert.zip