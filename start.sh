#!/bin/sh

### get the name of the repository
REPO_NAME=$(basename -s .git `git config --get remote.origin.url`)

echo "CREATING DOCKER VOLUME $REPO_NAME-storage"
### remove volume if it exists already
docker volume rm -f $REPO_NAME-storage

### create volume
docker volume create $REPO_NAME-storage

# build image from Dockerfile
docker build -f git-cloner.Dockerfile -t $REPO_NAME-git-cloner .

### run image as container
docker run \
--name $REPO_NAME-git-cloner \
-v $REPO_NAME-storage:/storage \
-e GIT_REPO_URL=$(git remote get-url origin) \
-e GIT_USERNAME=$(git config --global user.name) \
-e GIT_EMAIL=$(git config --global user.email) \
-e GIT_REPO_NAME=$REPO_NAME \
$REPO_NAME-git-cloner

### remove container
echo "REMOVING THE CONTAINER $REPO_NAME-git-cloner";
docker container rm -f $REPO_NAME-git-cloner

### remove image
echo ""
echo "REMOVING THE IMAGE $REPO_NAME-git-cloner";
docker image rm -f $REPO_NAME-git-cloner
echo ""

docker run \
--name $REPO_NAME-composer-runner \
-v $REPO_NAME-storage:/storage \
-v /var/run/docker.sock:/var/run/docker.sock \
docker \
sh -c "cd /storage/branches && export COMPOSE_PROJECT_NAME=$REPO_NAME && docker-compose up -d"

### remove container
echo "REMOVING THE CONTAINER $REPO_NAME-composer-runner";
docker container rm -f $REPO_NAME-composer-runner