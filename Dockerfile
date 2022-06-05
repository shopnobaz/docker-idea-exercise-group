##FROM mysql:debian

## export MYSQL_TCP_PORT="$PORT" \
## && mysqld \
##&& --user=root \
# This just keeps the container running (no Apache start)
##CMD tail -f /dev/null


##FROM bitnami/mysql:5.7.38

### Allow empty password 
### (= easier connection settings during development)
##ENV ALLOW_EMPTY_PASSWORD=yes

### Set the port to start the MySQL server on
##ENV MYSQL_PORT_NUMBER=$PORT


FROM mysql
ENV MYSQL_ROOT_PASSWORD="mysql"
ENV MYSQL_DATABASE="countries"
ENV MYSQL_TCP_PORT=$PORT