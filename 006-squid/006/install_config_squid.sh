#!/bin/bash


lanip=`ifconfig |grep 'inet addr'|grep -v 127.0.0.1|awk -F '[:| ]+' '{print $4}'|grep 10.9`
wanip1=`ifconfig |grep 'inet addr'|grep -v 127.0.0.1|awk -F '[:| ]+' '{print $4}'|grep -v 10.9|head -n 1`
wanip2=`ifconfig |grep 'inet addr'|grep -v 127.0.0.1|awk -F '[:| ]+' '{print $4}'|grep -v 10.9|head -n 2|tail -n 1`
wanip3=`ifconfig |grep 'inet addr'|grep -v 127.0.0.1|awk -F '[:| ]+' '{print $4}'|grep -v 10.9|tail -n 1`


sudo apt-get update
sudo apt-get install -y squid

cat >/etc/squid/squid.conf <<EOF 
http_port ${lanip}:4000
http_port ${lanip}:4001
http_port ${lanip}:4002
coredump_dir /var/spool/squid
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern (Release|Packages(.gz)*)$      0       20%     2880
refresh_pattern .               0       20%     4320

via off
forwarded_for delete

acl lan src 10.99.0.0/16
http_access allow lan

acl all src 0.0.0.0
http_access allow all

acl port4000 myport 4000
http_access allow port4000
tcp_outgoing_address ${wanip1} port4000

acl port4001 myport 4001
http_access allow port4001
tcp_outgoing_address ${wanip2} port4001

acl port4002 myport 4002
http_access allow port4002
tcp_outgoing_address ${wanip3} port4002
EOF

sudo systemctl restart squid
