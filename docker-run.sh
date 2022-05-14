#!/bin/sh
docker build -t start-up-app .
docker run \
-e GIT_REPO_URL=$(git remote get-url origin) \
-e GIT_USERNAME=$(git config --global user.name) \
-e GIT_EMAIL=$(git config --global user.email) \
start-up-app

# for later
# -v /var/run/docker.sock:/var/run/docker.sock