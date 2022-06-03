FROM nginx

##CMD tail -f /dev/null


CMD ["nginx" "-g" "daemon off;"]