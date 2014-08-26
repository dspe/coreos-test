FROM debian:sid
MAINTAINER Philippe Vincent-Royol <vincent.royol@gmail.com>

# Install packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 libapache2-mod-php5 \
                php5 php5-intl php5-xsl php5-intl php-apc php5-curl php5-mcrypt php5-mysqlnd php-pear \
                curl imagemagick pwgen jq
                
# Add configuration files
RUN mkdir -p /var/log/apache2/
ADD local.ini /etc/php5/apache2/conf.d/local.ini
ADD 001-ez53.conf /etc/apache2/sites-available/001-ez53.conf

# Enable virtualhost configuration
RUN a2dissite 000-default.conf
RUN a2ensite 001-ez53.conf
RUN a2enmod rewrite

# Add ezpublish file
COPY ezpublish5-5.3.0-ee-bul-full.tar.gz /var/www/ezpublish5.tar.gz
ADD kickstart.ini /kickstart.ini

# Apache Environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_ENVIRONMENT prod
ENV APACHE_SERVERNAME localhost
#ENV APACHE_ALIASNAME admin.localhost

EXPOSE 80

# Our final script
ADD boot.sh /boot.sh
RUN chmod +x /boot.sh
CMD ["/boot.sh"]
