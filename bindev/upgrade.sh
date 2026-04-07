#!/bin/bash

bin/moodle-docker-compose exec webserver php admin/cli/upgrade.php --non-interactive

echo "======================"
bin/moodle-docker-compose exec webserver php admin/cli/purge_caches.php
echo "Purge caches executed."