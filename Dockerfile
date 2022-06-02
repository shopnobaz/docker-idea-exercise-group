FROM mysql:debian
CMD export MYSQL_TCP_PORT="$PORT" \
  && mysqld