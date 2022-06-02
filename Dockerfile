FROM alpine:3.14

CMD npm install && npm run build && npm start