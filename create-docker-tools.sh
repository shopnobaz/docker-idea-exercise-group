#!/bin/sh
rm -r docker-tools
cp -r docker-tools-template docker-tools
echo "./docker-tools/start.sh" > start
echo "./docker-tools/stop.sh" > stop
chmod 777 start
chmod 777 stop