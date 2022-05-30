FROM debian:buster-slim
EXPOSE 3306 33060
CMD ["mysqld"]

#CMD chmod -R 755 /storage/branches/country-info-db \
#&& ln -s /storage/branches/country-info-db/* /var/www/html \
#&& apache2-foreground