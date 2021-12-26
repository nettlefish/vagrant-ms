#!/usr/bin/env bash
set -e

export DEBIAN_FRONTEND=noninteractive

mv /etc/localtime /etc/localtime.orig
cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

cp /etc/multipath.conf  /etc/multipath.conf.orig
cat <<EOF >>/etc/multipath.conf
blacklist {
    devnode "^sda"
    devnode "^sdb"
}
EOF


PKG_PATH="/vagrant/pkgs"
GRAFANA_VERSION="8.3.3"

PARCHIVE="https://dl.grafana.com/oss/release/grafana_${GRAFANA_VERSION}_amd64.deb"
ARCHIVE="grafana_${GRAFANA_VERSION}_amd64.deb"


TMPD=$(mktemp -d)


apt install -y libfontconfig
wget -O "${TMPD}/${ARCHIVE}" "${PARCHIVE}"


dpkg -i "${TMPD}/${ARCHIVE}"

install -m 0644 -D /vagrant/scripts/grafana-resources/node-exporter-full_rev24.json /etc/grafana/provisioning/dashboards/node-exporter-full_rev24.json
install -m 0644 -D /vagrant/scripts/grafana-resources/apache_rev1.json /etc/grafana/provisioning/dashboards/apache_rev1.json
install -m 0644 -D /vagrant/scripts/grafana-resources/prometheus-con.yaml /etc/grafana/provisioning/datasources/prometheus-con.yaml

systemctl daemon-reload
systemctl enable grafana-server
systemctl start grafana-server

systemctl stop multipath-tools
systemctl start multipath-tools



