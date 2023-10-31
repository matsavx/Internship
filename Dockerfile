FROM ubuntu:20.04
 
ENV TZ=Europe/Moscow

RUN apt update -y
RUN apt install -y nginx
RUN rm -f /var/www/html/index.nginx-debian.html 
COPY ./html/ /var/www/html/

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
 
CMD nginx
 
EXPOSE 80
