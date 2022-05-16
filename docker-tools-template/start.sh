#!/bin/sh

# Get the dir path of the dir where this script is located
DIRNAME=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Get the repo dir path
REPO_DIR="$(dirname "$DIRNAME")"

# Cd to the dir where this script is located
cd $DIRNAME

### get the name of the repository
REPO_NAME=$(basename -s .git `git config --get remote.origin.url`)

## get the name of the checked out branch
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

## dockerSettings.json file path
DOCKER_SETTINGS_FILE="$REPO_DIR/dockerSettings.json"

if [ ! -f "$DOCKER_SETTINGS_FILE" ]; then
  echo ""
  echo "Can not compose containers because there is no"
  echo "dockerSettings.json file found in this branch..."
  echo ""
  echo "Please create one. This is an example:"
  echo ""
  cat ./dockerSettingsExample.json
  echo ""
  echo ""
  exit 1
fi

## copy dockerSettings.json into the copy-to-docker-folder
rm copy-to-docker-container/dockerSettings.json
cp $DOCKER_SETTINGS_FILE copy-to-docker-container/dockerSettings.json

echo ""
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
-e GIT_BRANCH_NAME=$BRANCH_NAME \
-e HOST_REPO_PATH=$REPO_DIR \
$REPO_NAME-git-cloner

### remove container
echo "REMOVING THE CONTAINER $REPO_NAME-git-cloner";
docker container rm -f $REPO_NAME-git-cloner

### remove image
echo ""
echo "REMOVING THE IMAGE $REPO_NAME-git-cloner";
docker image rm -f $REPO_NAME-git-cloner
echo ""

exit 1

### create a container based on the official docker image
### that runs docker (mounted as a socket)
### and docker and docker compose commands inside it
### Run docker compose on dynamically created yml file.
echo "CREATING THE CONTAINER $REPO_NAME-composer-runner"
echo "--> running docker-compose up -d"
docker run \
--name $REPO_NAME-composer-runner \
-v $REPO_NAME-storage:/storage \
-v /var/run/docker.sock:/var/run/docker.sock \
docker \
sh -c "cd /storage/branches && export COMPOSE_PROJECT_NAME=$REPO_NAME && docker-compose up -d"

### remove the docker composer-runner container
echo ""
echo "REMOVING THE CONTAINER $REPO_NAME-composer-runner"
docker container rm -f $REPO_NAME-composer-runner

echo ""
echo "Up and running! :)"
echo ""