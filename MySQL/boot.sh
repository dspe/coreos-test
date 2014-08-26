#!/bin/bash
set -e

VOLUME_HOME="/var/lib/mysql"

if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    mysql_install_db  --user=mysql > /dev/null 2>&1
    echo "=> Done!"  

    # Start mysql server
    echo "=> Starting mysql server..."
    /usr/bin/mysqld_safe --skip-syslog > /dev/null 2>&1 &

    # timeout
    timeout=120
    while ! mysqladmin -uroot ping >/dev/null 2>&1
    do
        timeout=$(expr $timeout - 1)
		if [ $timeout -eq 0 ]; then
			echo "Timeout error occurred trying to start MySQL Daemon."
			exit 1
		fi
		sleep 1
	done

    /create_mysql_admin_user.sh
else
    echo "=> Using an existing volume of MySQL"
    /usr/bin/mysqld_safe --skip-syslog > /dev/null 2>&1 &
fi

tail -F /var/log/mysql/*.log
