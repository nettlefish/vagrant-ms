#!/usr/bin/env bash
set -e

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
PROMETHEUS_VERSION="2.24.1"
ARCHIVE="prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz"

if ! id prometheus > /dev/null 2>&1 ; then
  useradd --system prometheus
fi

TMPD=$(mktemp -d)

tar zxf "${PKG_PATH}/${ARCHIVE}" -C $TMPD --strip-components=1

install -m 0644 -D -t /usr/share/prometheus/consoles $TMPD/consoles/*
install -m 0644 -D -t /usr/share/prometheus/console_libraries $TMPD/console_libraries/*
install -m 0755 $TMPD/prometheus $TMPD/promtool /usr/bin/
install -d -o prometheus -g prometheus /var/lib/prometheus
install -m 0644 /vagrant/scripts/prometheus.service /etc/systemd/system/
install -m 0644 -D /vagrant/scripts/prometheus.yml /etc/prometheus/prometheus.yml
install -m 0644 /vagrant/scripts/alerting_rules.yml /etc/prometheus/

systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus

systemctl stop multipath-tools
systemctl start multipath-tools


sh /vagrant/scripts/blackbox_exporter.sh
