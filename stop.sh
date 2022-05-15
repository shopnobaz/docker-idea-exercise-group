#!/bin/sh

### get the name of the repository
REPO_NAME=$(basename -s .git `git config --get remote.origin.url`)

### remove containers with names starting with the REPO_NAME
CONTAINERS_TO_REMOVE=$(docker ps --filter=name="$REPO_NAME*" -q)
docker rm -f $CONTAINERS_TO_REMOVE

### sleep a short while giving time for the containers to shut down
sleep 2

### remove images with references starting with th REPO__NAME
IMAGES_TO_REMOVE=$(docker images -a --filter=reference="$REPO_NAME*" -q)
docker rmi -f $IMAGES_TO_REMOVE

### Remove the docker image
### Don't normally since it takes time to recreate/download
# IMAGES_TO_REMOVE=$(docker images -a --filter=reference="docker" -q)
# docker rmi -f $IMAGES_TO_REMOVE

### remove all dangling and stopped images (will empty a lot of cache)
### if we do this the next start will take a long time...
# docker system prune -a

### remove volume
docker volume rm -f $REPO_NAME-storage

echo ""
echo "Containers, images and volume removed!"
echo "(Keeping the docker image to speed up next start...)"
echo ""