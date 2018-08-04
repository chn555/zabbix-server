#!/bin/bash


rpm -ivh https://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm

yum install yum-utils -y

 yum-config-manager --enable rhel-7-server-optional-rpms

 yum install zabbix-server-mysql mariadb mariadb-server -y

 mysql_secure_installation <<EOF

 y
 password
 password
 y
 y
 y
 y
 EOF

mysql -u root -p -e "create database zabbix character set utf8 collate utf8_bin;"
mysql -u root -p -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';"

zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix

sed -i -e 's/DBPassword=/DBPassword=zabbix/g' /etc/zabbix/zabbix_server.conf
