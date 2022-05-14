#!/bin/sh

# get the name of the repository
REPO_NAME=$(basename -s .git `git config --get remote.origin.url`)

# build image from Dockerfile
docker build -t $REPO_NAME .

### create volume
docker volume create $REPO_NAME-storage

### run image
docker run \
-v $REPO_NAME-storage:/storage \
-e GIT_REPO_URL=$(git remote get-url origin) \
-e GIT_USERNAME=$(git config --global user.name) \
-e GIT_EMAIL=$(git config --global user.email) \
$REPO_NAME

# for later
# -v /var/run/docker.sock:/var/run/docker.sock
# -v "$(pwd)/share:/share" \
