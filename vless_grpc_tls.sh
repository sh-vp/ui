#!/bin/bash
ufw allow 443
x-ui stop
rm -rf /etc/x-ui/x-ui.db
wget --no-check-certificate -O /etc/x-ui/x-ui.db https://github.com/sh-vp/ui/releases/latest/download/vless_grpc_tls.db
x-ui start
