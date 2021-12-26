#!/usr/bin/env bash

NETWORK="$1"
DOMAIN="$2"
START_IP="$3"

cat <<EOF >/etc/hosts
127.0.0.1       localhost
${NETWORK}1	MASTER${DOMAIN}	MASTER
${NETWORK}${START_IP}   prometheus${DOMAIN}    prometheus
${NETWORK}$((START_IP+1))   LAMP${DOMAIN}      LAMP 
${NETWORK}$((START_IP+2))   alertmanager${DOMAIN}  alertmanager
${NETWORK}$((START_IP+3))   grafana${DOMAIN}	grafana
EOF


