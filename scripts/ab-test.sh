#!/usr/bin/env bash
set -e

time="Start ab DataTime:"`date +%Y-%m-%d-%H:%M`

echo ${time}  >> /var/log/cronab-test.log

/usr/bin/ab -n 10000 -c 1000 http://LAMP:80/ >> /var/log/cronab-test.log

time="End ab DataTime:"`date +%Y-%m-%d-%H:%M`

echo ${time}  >> /var/log/cronab-test.log





