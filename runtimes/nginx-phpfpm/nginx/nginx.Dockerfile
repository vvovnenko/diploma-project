FROM nginx:1.25.3

ENV APP_HOST=localhost

RUN rm /etc/nginx/conf.d/default.conf
COPY ./runtimes/nginx-phpfpm/nginx/templates /etc/nginx/templates
COPY ./runtimes/nginx-phpfpm/nginx/nginx.conf /etc/nginx/nginx.conf
COPY "./project" "/var/www/app"
