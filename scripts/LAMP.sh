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

apt-get update

apt-get install -y git

apt-get install -y apache2

if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant/www /var/www
fi

a2enmod rewrite
systemctl restart apache2

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get install -y mysql-server


apt-get install -y php
apt-get install -y libapache2-mod-php
apt-get install -y php-mysql

systemctl restart apache2

sh /vagrant/scripts/apache_exporter.sh
sh /vagrant/scripts/mysqld_exporter.sh

apt-get -y  upgrade

systemctl stop multipath-tools
systemctl start multipath-tools


