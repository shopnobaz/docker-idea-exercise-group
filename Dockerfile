FROM php:8.0-apache
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN apt-get update && apt-get upgrade -y

CMD chmod -R 755 /storage/branches/country-info-db \
  && ln -s /storage/branches/country-info-db/* /var/www/html \
  && apache2-foreground