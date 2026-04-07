#!/bin/bash

echo "Starte Test Suite"
bin/moodle-docker-compose exec webserver php public/admin/tool/phpunit/cli/init.php

bin/moodle-docker-compose exec -e XDEBUG_CONFIG="idekey=PHPSTORM" -e PHP_IDE_CONFIG="serverName=mbsmoodle.local" webserver vendor/bin/phpunit $*
