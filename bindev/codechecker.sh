#!/bin/bash

echo "Starte Codechecker"
if [ -d ~/moodle-plugin-ci ]; then
    echo "Using moodle-plugin-ci"
    ~/moodle-plugin-ci/bin/moodle-plugin-ci phpcs $1
else
    echo "Using local codechecker"
    bin/moodle-docker-compose exec webserver php public/local/codechecker/run.php $1
fi