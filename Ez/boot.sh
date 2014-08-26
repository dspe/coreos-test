#!/bin/bash

# Uncompress ezpublish5.tar.gz
echo "=> Uncompress ezpublish5.tar.gz"
cd /var/www/ && tar xfz ezpublish5.tar.gz
chown -R www-data:www-data /var/www

cat /etc/apache2/envvars

# Create some variables
PASSWORD=$(/usr/bin/curl -L 172.17.8.101:4001/v2/keys/ez/mysql | jq '.node.value' || "password" )
DATABASE="ez-$(pwgen 6 1)"

echo "========================================================================"
echo "Check paramters..."
echo ""
echo "=> Url: ${APACHE_SERVERNAME}"
echo "=> Environment: ${APACHE_ENVIRONMENT}"
echo "=> Password: $PASSWORD"
echo "=> Database: $DATABASE"
echo "========================================================================"

# Update kickstart.ini
sed -i -e "s/\*\*password\*\*/$PASSWORD/g" /kickstart.ini
sed -i -e "s/\*\*database\*\*/$DATABASE/g" /kickstart.ini
sed -i -e "s/\*\*ez_url\*\*/$APACHE_SERVERNAME/g" /kickstart.ini
sed -i -e "s/\*\*ez_fo_url\*\*/$APACHE_SERVERNAME/g" /kickstart.ini
#cat /kickstart.ini | egrep -v "^\s*(#|$)"

# Move kickstart.ini to final directory
cp /kickstart.ini /var/www/ezpublish5/ezpublish_legacy/

# Start Apache
echo "=> Start Apache2"
#/usr/sbin/apache2 -D FOREGROUND
service apache2 configtest
service apache2 restart

echo "=> Read log files"
tail -F /var/log/apache2/*.log
