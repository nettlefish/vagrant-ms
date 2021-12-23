#!/usr/bin/env bash
set -e

PKG_PATH=/vagrant/pkgs
APACHE_EXPORTER_VERSION="0.11.0"
ARCHIVE="apache_exporter-${APACHE_EXPORTER_VERSION}.linux-amd64.tar.gz"

if ! id apache_exporter > /dev/null 2>&1 ; then
  useradd --system apache_exporter
fi

tar zxf "${PKG_PATH}/${ARCHIVE}" -C /usr/bin --strip-components=1 --wildcards */apache_exporter
install -m 0644 /vagrant/scripts/apache_exporter.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable apache_exporter
systemctl start apache_exporter

