# start with a debian node container
FROM node:16.15-buster

# Set a work dir (working directory)
WORKDIR /storage/branches/dev-frontend

# Run necessary start commands
CMD npm install && npm run dev