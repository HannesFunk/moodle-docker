#!/bin/bash

bin/moodle-docker-compose exec webserver php admin/cli/build_theme_css.php
echo "CSS built."
