FROM mysql:debian
# export MYSQL_TCP_PORT="$PORT" \
CMD  mysqld 
# This just keeps the container running (no Apache start)
# &&  tail -f /dev/nul