FROM mysql:debian

CMD export MYSQL_TCP_PORT="$PORT" \
  && mysqld \
  && mysqld --user=root \
  # This just keeps the container running (no Apache start)
  &&  tail -f /dev/nul