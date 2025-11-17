FROM debian:12.4

RUN apt-get update && apt-get install -y php8.2-fpm curl php8.2-mysql mariadb-client

RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

COPY ./tools/script.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/script.sh

RUN sed -ir "s/listen = \/run\/php\/php8.2-fpm.sock/listen = 0.0.0.0:9000/1" /etc/php/8.2/fpm/pool.d/www.conf

CMD ["bash", "/usr/local/bin/script.sh"]