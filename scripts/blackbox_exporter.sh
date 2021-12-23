#!/usr/bin/env bash
set -e

PKG_PATH=/vagrant/pkgs
BLACKBOX_EXPORTER_VERSION="0.19.0"
ARCHIVE="blackbox_exporter-${BLACKBOX_EXPORTER_VERSION}.linux-amd64.tar.gz"

if ! id blackbox_exporter > /dev/null 2>&1 ; then
  useradd --system blackbox_exporter
fi

tar zxf "${PKG_PATH}/${ARCHIVE}" -C /usr/bin --strip-components=1 --wildcards */blackbox_exporter
install -m 0644 /vagrant/scripts/blackbox_exporter.service /etc/systemd/system/
install -d -m 0755 -o blackbox_exporter -g blackbox_exporter /etc/blackbox_exporter/
install -m 0644 -D /vagrant/scripts/blackbox.yml /etc/blackbox_exporter/blackbox.yml

setcap cap_net_raw+ep /usr/bin/blackbox_exporter

systemctl daemon-reload
systemctl enable blackbox_exporter
systemctl start blackbox_exporter

