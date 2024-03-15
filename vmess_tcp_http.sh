#!/bin/bash

x-ui stop
rm -rf /etc/x-ui/x-ui.db
wget --no-check-certificate -O /etc/x-ui/x-ui.db https://github.com/sh-vp/ui/releases/latest/download/vmess_tcp_http.db
x-ui start
