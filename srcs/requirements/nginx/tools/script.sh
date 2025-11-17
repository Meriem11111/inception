#!/bin/bash


if [ ! -f /etc/nginx/ssl/certificate.crt ] || [ ! -f /etc/nginx/ssl/certificate.key ]; then
    echo "Generating SSL certificate..."
    openssl req -x509 \
        -nodes \
        -out "/etc/nginx/ssl/certificate.crt" \
        -keyout "/etc/nginx/ssl/certificate.key" \
        -subj "/C=MA/ST=BG/L=Benguerir/O=42/OU=42/CN=42.meabdelk.fr/UID=meabdelk" \
        -days 365
fi

exec nginx -g "daemon off;"