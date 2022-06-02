FROM php:apache-bullseye
# This just keeps the container running (no Apache start)
CMD tail -f /dev/null
