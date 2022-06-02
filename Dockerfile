FROM mysql:debian

## export MYSQL_TCP_PORT="$PORT" \
## && mysqld \
##&& --user=root \
# This just keeps the container running (no Apache start)
CMD tail -f /dev/null