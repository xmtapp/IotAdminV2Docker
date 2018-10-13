#!/bin/bash

#查看mysql服务的状态，方便调试，这条语句可以删除
echo `service mysql status`

echo '启动mysql服务....'
#启动mysql
usermod -d /var/lib/mysql/ mysql
chown -R mysql:mysql /var/lib/mysql
service mysql start

tail -f /dev/null