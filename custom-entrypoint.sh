#!/bin/sh

source /root/magento_config

VERSION=""

if [ -f composer.json ]; then
    VERSION=$(grep -oP '"version":\s*"\K[^"]+' composer.json)
    VERSION=" $VERSION"
fi

wait_for_elasticsearch() {
    local start_time=$(date +%s)
    local end_time=$((start_time + 120))

    while ! nc -z localhost 9200 >/dev/null 2>&1; do
        current_time=$(date +%s)
        if [ "$current_time" -ge "$end_time" ]; then
            echo "Elasticsearch Timeout!"
            exit 1
        fi
        sleep 1
    done
}

echo -e "\n\n\e[34m __  __                        _        \e[0m"
echo -e "\e[34m|  \/  | __ _  __ _  ___ _ __ | |_ ___  \e[0m"
echo -e "\e[34m| |\/| |/ _\` |/ _\` |/ _ \ '_ \| __/ _ \ \e[0m"
echo -e "\e[34m| |  | | (_| | (_| |  __/ | | | || (_) |\e[0m"
echo -e "\e[34m|_|  |_|\__,_|\__, |\___|_| |_|\__\___/ \e[0m"
echo -e "\e[34m              |___/                     \e[0m\n"

# Start elasticsearch
echo -n "Start elasticsearch..."
su elasticsearch -c 'start_elasticsearch'
wait_for_elasticsearch
echo -e "\e[32mok\e[0m"

# Start mysql
echo -n "Start mysql..."
service mysql start > /dev/null 2>&1
echo -e "\e[32mok\e[0m"

# Start nginx
echo -n "Start nginx..."
service nginx start > /dev/null 2>&1
echo -e "\e[32mok\e[0m"

# Start php-fpm
echo -n "Start php-fpm..."
service $PHP_FPM_SERVICE start > /dev/null 2>&1
$PHP_FPM_CLI -D -R > /dev/null 2>&1
echo -e "\e[32mok\e[0m"

# Testing
curl -s http://localhost:$PORT | grep -q "magento-init"

if [ $? -eq 0 ]; then
    echo -e "\n\e[32mMagento$VERSION is ready to use.\e[0m"
    echo -e "➞ Customer View:     \e[34mhttp://localhost:$PORT/\e[0m"
    echo -e "➞ Admin:             \e[34mhttp://localhost:$PORT/admin/\e[0m (admin/admin123)"
    echo -e "\e[33mWarning: Data will be lost if you exit this session.\e[0m\n"
else
    echo -e "\e[31mSetup failed!\e[0m"
    exit 1
fi

exec "$@"