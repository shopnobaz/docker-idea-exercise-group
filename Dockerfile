FROM mysql:debian
CMD export MYSQL_TCP_PORT="$PORT" \
  && mysqld \
  # This just keeps the container running (no Apache start)
  &&  tail -f /dev/nul