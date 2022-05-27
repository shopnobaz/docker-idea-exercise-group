FROM php:8.0-apache

EXPOSE 80

CMD  ln -s /storage/branches/country-info /var/www/html && apache2-foreground