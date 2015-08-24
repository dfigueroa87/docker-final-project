FROM ubuntu:14.04.2

MAINTAINER David Figueroa <dfigueroa@devspark.com>

# Update and install
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install apache2 libapache2-mod-php5 php5-mysql php5-gd php-pear php-apc php5-curl curl lynx-cur

# Apache
RUN a2enmod php5
RUN a2enmod rewrite

# Environment vars
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV WORLD_API_DOCUMENT_ROOT /opt/www/worldapi/public/
ENV WORLD_API_SERVER_NAME api.world.com.ar

EXPOSE 80

# Config files
COPY apache2.conf /etc/apache2/apache2.conf
COPY worldapi.conf /etc/apache2/sites-available/worldapi.conf
RUN a2ensite worldapi.conf

# Migration and permissions
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Go go go!
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
