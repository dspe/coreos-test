FROM ubuntu:latest
MAINTAINER Philippe Vincent-Royol <vincent.royol@gmail.com>

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server pwgen

RUN rm -rf /var/lib/mysql/*

ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD boot.sh /boot.sh
RUN chmod 755 /*.sh

ENV MYSQL_USER admin
ENV MYSQL_PASS **Random**

VOLUME ["/etc/mysql", "/var/lib/mysql"]
EXPOSE 3306

CMD ["/boot.sh"]

