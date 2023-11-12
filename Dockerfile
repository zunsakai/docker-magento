FROM zunsakai/base:php8.1-mysql8-elasticsearch7-nginx

USER root

ARG MAGENTO_VERSION
COPY magento/$MAGENTO_VERSION /root/magento_config

# Copy magento
RUN . /root/magento_config \
    && rm -rf /var/www/html/* \
    && wget -q -O /tmp/magento.zip $MAGENTO_URL \
    && unzip -qq /tmp/magento.zip -d /tmp/magento \
    && cp -r /tmp/magento/magento*/* /var/www/html \
    && wget -q -O /tmp/magento-sample-data.zip $SAMPLE_DATA_URL \
    && unzip -qq /tmp/magento-sample-data.zip -d /tmp/magento-sample-data \
    && cp -r /tmp/magento-sample-data/magento*/* /var/www/html \
    && rm -rf /tmp/*

# Composer install
RUN COMPOSER_ALLOW_SUPERUSER=1 composer install

# Config PORT
RUN . /root/magento_config \
    && echo "listen $PORT default_server;" > /etc/nginx/listen_default.conf

# Install magento
RUN . /root/magento_config \
    && su elasticsearch -c 'start_elasticsearch' \
    && service mysql start \
    && service nginx start \
    && service $PHP_FPM_SERVICE start \
    && $PHP_FPM_CLI -D -R \
    && sleep 30 \
    && service mysql status \
    && service nginx status \
    && service $PHP_FPM_SERVICE status \
    && curl http://localhost:9200 \
    && php -d memory_limit=-1 bin/magento setup:install \
        --base-url=http://localhost:$PORT \
        --db-host=127.0.0.1 \
        --db-name=magento_db \
        --db-user=magento \
        --db-password=magento \
        --admin-firstname=admin \
        --admin-lastname=admin \
        --admin-email=admin@admin.com \
        --admin-user=admin \
        --admin-password=admin123 \
        --use-rewrites=1 \
        --backend-frontname=admin \
        --search-engine=elasticsearch7 \
        --elasticsearch-host=127.0.0.1 \
        --elasticsearch-port=9200 \
        --cleanup-database

# Add n98 command
RUN wget -O /var/www/html/n98-magerun2.phar https://files.magerun.net/n98-magerun2-latest.phar

# Entrypoint
ADD custom-entrypoint.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/custom-entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/custom-entrypoint.sh" ]

EXPOSE 3306 9200
