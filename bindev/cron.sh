#!/bin/bash

bin/moodle-docker-compose exec webserver sh -c "cd /var/www/html; /usr/local/bin/php admin/cli/cron.php" |grep -v "Redis lock"

echo "Cron Ausfürhung beendet."
