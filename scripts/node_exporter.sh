#!/usr/bin/env bash
set -e

PKG_PATH=/vagrant/pkgs
NODE_EXPORTER_VERSION="1.0.1"
ARCHIVE="node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"

if ! id node_exporter > /dev/null 2>&1 ; then
  useradd --system node_exporter
fi

tar zxf "${PKG_PATH}/${ARCHIVE}" -C /usr/bin --strip-components=1 --wildcards */node_exporter
install -m 0644 /vagrant/scripts/node_exporter.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter

