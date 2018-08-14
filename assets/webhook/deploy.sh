#!/usr/bin/env bash

export $(cat ~/.env | xargs)
log=$(dirname ${BASH_SOURCE})/deploy.log

git fetch
cat $log

L=$(git rev-parse @)
R=$(git rev-parse @{u})

if [ $L != $R ]; then
  git status -uno > $log
  git reset --hard HEAD >> $log
  git pull --force >> $log
  composer install >> $log
  mysql db < db/schema.sql
  mysql db < db/data.sql
  curl -g "https://api.telegram.org/${token}/sendMessage?chat_id=${chat}&parse_mode=markdown&text=[Site](${site}) updated. [Deploy Log](${site}:9000/hooks/deploy). [Current Status](${site}:9000/hooks/status).&"
fi

