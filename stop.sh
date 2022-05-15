#!/bin/sh

### get the name of the repository
REPO_NAME=$(basename -s .git `git config --get remote.origin.url`)

### remove containers with names starting with the REPO_NAME
echo ""
echo "Removing containers..."
docker ps --filter=name="$REPO_NAME*"
docker rm -f $(docker ps -a --filter=name="$REPO_NAME*" -q)

### remove images with references starting with th REPO__NAME
echo ""
echo "Removing images..."
docker images -a --filter=reference="$REPO_NAME*"
### (the xargs part removes duplicate id:s)
docker rmi -f $(docker images -a --filter=reference="$REPO_NAME*" -q | xargs -n1 | sort -u | xargs)

### remove volume
echo ""
echo "Removing volume..."
docker volume rm -f $REPO_NAME-storage

echo ""
echo "Containers, images and volume removed!"
echo "(Kept the docker image to speed up next start...)"
echo ""


