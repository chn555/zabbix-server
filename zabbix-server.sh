#!/bin/bash


rpm -ivh https://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm

yum install yum-utils -y

 yum-config-manager --enable rhel-7-server-optional-rpms

 yum install zabbix-server-mysql mariadb mariadb-server -y

systemctl enable mariadb --now

 mysql_secure_installation <<EOF

 y
 password
 password
 y
 y
 y
 y
 EOF

echo "Enter root SQL password"
mysql -u root -p -e "create database zabbix character set utf8 collate utf8_bin;"
mysql -u root -p -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';"


echo "Enter zabbix SQL password"
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix

sed -i -e 's/# DBHost=localhost/DBHost=localhost/g' /etc/zabbix/zabbix_server.conf

sed -i -e 's/DBPassword=/DBPassword=zabbix/g' /etc/zabbix/zabbix_server.conf

systemctl enable zabbix-server --now
