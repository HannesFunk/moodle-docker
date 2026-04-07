#!/bin/bash
bin/moodle-docker-compose exec webserver pecl install xdebug
echo "You may have to adjust the IP Adress in this script"
ip=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
echo $ip
read -r -d '' conf <<'EOF'
; Settings for Xdebug Docker configuration
zend_extension = xdebug
xdebug.mode = debug
xdebug.client_host = 192.168.178.139
xdebug.max_nesting_level = 512
xdebug.start_with_request = yes
EOF
bin/moodle-docker-compose exec webserver bash -c "echo '$conf' > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini"
bin/moodle-docker-compose exec webserver docker-php-ext-enable xdebug
bin/moodle-docker-compose restart webserver

# The client_host IP Adress is the ip adress pointing from within the docker to the host.
# ifconfig in the host system. => IP
