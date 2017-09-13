host="squid6"
scp ./interfaces ${host}:/tmp
ssh ${host} 'mv /tmp/interfaces /etc/network/'
ssh ${host} 'sudo service networking restart'

scp ./install_config_squid.sh ${host}:/tmp/squid.sh
ssh ${host} 'bash /tmp/squid.sh'
ssh ${host} 'rm -f /tmp/squid.sh'
