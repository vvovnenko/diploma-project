FROM nginx:1.25.3
COPY ./runtimes/nginx_phpfpm/nginx/conf.d/www.conf /etc/nginx/conf.d/default.conf
COPY "./project" "/var/www/app"
