#!/usr/bin/env bash
set -e

PKG_PATH=/vagrant/pkgs
MYSQLD_EXPORTER_VERSION="0.13.0"
ARCHIVE="mysqld_exporter-${MYSQLD_EXPORTER_VERSION}.linux-amd64.tar.gz"

if ! id mysqld_exporter > /dev/null 2>&1 ; then
  useradd --system mysqld_exporter
fi

tar zxf "${PKG_PATH}/${ARCHIVE}" -C /usr/bin --strip-components=1 --wildcards */mysqld_exporter
install -m 0644 /vagrant/scripts/mysqld_exporter.service /etc/systemd/system/

cat > /etc/.mysqld_exporter.cnf <<EOF
[client]
user=root
password=root
EOF


systemctl daemon-reload
systemctl enable mysqld_exporter
systemctl start mysqld_exporter

