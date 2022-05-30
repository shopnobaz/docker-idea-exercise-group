FROM php:8.0-apache

EXPOSE 80

RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN apt-get update && apt-get upgrade -y

CMD chmod -R 755 /storage/branches/country-info \
  && ln -s /storage/branches/country-info/* /var/www/html \
  && apache2-foreground



