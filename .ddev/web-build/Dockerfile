RUN apt-get update && \
    apt-get install -y --no-install-recommends php8.3-imap && \
    phpenmod imap && \
    rm -rf /var/lib/apt/lists/*

RUN php -r "copy('https://getcomposer.org/installer','/tmp/composer-installer');" && \
    php /tmp/composer-installer --install-dir=/usr/local/bin --filename=composer && \
    rm /tmp/composer-installer
