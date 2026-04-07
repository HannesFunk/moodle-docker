#!/bin/bash

echo "Starte Moodlecheck"
bin/moodle-docker-compose exec webserver php public/local/moodlecheck/cli/moodlecheck.php -p=$1
