FROM debian:12.11

RUN apt-get update && apt-get install -y nginx \
    && apt-get install -y openssl

RUN mkdir -p /etc/nginx/ssl 

RUN rm -f /etc/nginx/sites-enabled/default

COPY conf/config.conf /etc/nginx/sites-available/default

RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

COPY ./tools/script.sh .

RUN chmod +x script.sh

EXPOSE 443

CMD ["./script.sh"]
