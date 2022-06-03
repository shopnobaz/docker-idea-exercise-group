FROM nginx

CMD rm -r /usr/share/nginx/html \
  # create a symbolic link from work dir to /usr/share/nginx/html
  && ln -s $(pwd) /usr/share/nginx/html \
  ### change port
  && sed -i "s/80/$PORT/" /etc/nginx/conf.d/default.conf \
  # try starting nginx
  && nginx -g 'daemon off;'