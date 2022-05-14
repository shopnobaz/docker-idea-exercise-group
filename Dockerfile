# docker is docker's official image for running docker
# inside a container... :)
FROM node:16.15-buster

# Install git
RUN apt update
RUN apt install git

# Set a work dir (working directory)
WORKDIR /app

# Copy the contents of copy-to-docker-container folder 
# to the work dir
COPY ./copy-to-docker-container .

# install npm modules
RUN npm install

# Run the git-cloner.js file from copy-to-docker-container
CMD node git-cloner.js