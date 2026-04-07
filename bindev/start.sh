#!/bin/bash

dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
parentdir="$(dirname "$dir")"
mbsdockerroot=`basename "$parentdir"`;
networkname="mbshubnet"

echo "Zertifikate werden neu generiert"

cd traefik/

mkcert -cert-file certs/local-cert.pem -key-file certs/local-key.pem "mbsmoodle.local" "mbsmoodle2.local" "teachshare.local" "prometheus.local" "grafana.local" "phpmyadmin.local" "qaworker.local"

echo "Netzwerk wird neu initialisiert"

docker network rm $networkname
docker network create $networkname

cd ..

echo "VS Code wird gestartet..."

cd mbsmoodle
# code .
cd ..

echo "Docker wird gestartet"

bin/moodle-docker-compose up -d --force-recreate --remove-orphans

# docker cp ca-cert.crt qaworker:/etc/ssl/certs/local-ca-cert.crt
docker cp /etc/ssl/certs/ca-certificates.crt moodle-quiz-archive-worker:/usr/local/share/ca-certificates/local-ca-cert.crt
bin/moodle-docker-compose exec -u root -t moodle-quiz-archive-worker chmod 644 /usr/local/share/ca-certificates/local-ca-cert.crt
bin/moodle-docker-compose exec -u root -t moodle-quiz-archive-worker update-ca-certificates
