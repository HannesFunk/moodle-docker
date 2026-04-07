#!/bin/bash

set -euo pipefail

if [ $# -eq 0 ]; then
	echo "Starte interaktive Docker bash Shell"
	bin/moodle-docker-compose exec -it webserver bash
else
	echo "Führe Befehl in Docker bash aus: $*"
	bin/moodle-docker-compose exec -it webserver bash -lc "$*"
fi
