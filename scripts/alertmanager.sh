#!/usr/bin/env bash
set -e

mv /etc/localtime /etc/localtime.bak
cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

cp  /etc/multipath.conf  /etc/multipath.conf.orig
cat <<EOF >>/etc/multipath.conf
blacklist {
    devnode "^sda"
    devnode "^sdb"
}
EOF

PKG_PATH="/vagrant/pkgs"
ALERTMANAGER_VERSION="0.21.0"

ARCHIVE="alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz"

if ! id alertmanager > /dev/null 2>&1 ; then
  useradd --system alertmanager
fi

TMPD=$(mktemp -d)

tar zxf "${PKG_PATH}/${ARCHIVE}" -C $TMPD --strip-components=1

install -m 0755 $TMPD/{alertmanager,amtool} /vagrant/scripts/gethook /usr/bin/
install -d -o alertmanager -g alertmanager /var/lib/alertmanager
install -m 0644 /vagrant/scripts/{alertmanager,gethook}.service /etc/systemd/system/
install -m 0644 -D /vagrant/scripts/alertmanager.yml /etc/alertmanager/alertmanager.yml
install -m 0644 -D /vagrant/scripts/template/alert_mail.tmpl /etc/alertmanager/template/alert_mail.tmpl
install -m 0644 -D /vagrant/scripts/template/alert_wecom.tmpl /etc/alertmanager/template/alert_wecom.tmpl


systemctl daemon-reload
systemctl enable alertmanager
systemctl start alertmanager

systemctl enable gethook
systemctl start gethook

systemctl stop multipath-tools
systemctl start multipath-tools

apt install -y cron
apt install -y apache2-utils

systemctl stop cron
systemctl start cron

install -m 0755 /vagrant/scripts/ab-test.sh /usr/bin

touch /var/spool/cron/crontabs/root
chmod 0600 /var/spool/cron/crontabs/root

echo "1,10,20,30,40,50 * * * * /usr/bin/ab-test.sh " >> /var/spool/cron/crontabs/root



