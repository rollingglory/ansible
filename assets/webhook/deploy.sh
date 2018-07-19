#!/usr/bin/env bash

log=$(dirname ${BASH_SOURCE})/deploy.log

git fetch
cat $log

L=$(git rev-parse @)
R=$(git rev-parse @{u})

if [ $L != $R ]; then
  git status -uno
  git pull origin master --force > $log
  composer install >> $log
  mysql db < db/schema.sql
  mysql db < db/data.sql
fi

