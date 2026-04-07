#!/bin/bash

echo "Starte Codechecker Autofix"
if [ -d ~/moodle-plugin-ci ]; then
    echo "Using moodle-plugin-ci"
    ~/moodle-plugin-ci/bin/moodle-plugin-ci phpcbf $1
else
    echo "Using local codechecker autofix"
    bin/moodle-docker-compose exec webserver public/local/codechecker/vendor/bin/phpcbf $1
fi