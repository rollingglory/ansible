#!/usr/bin/env bash

export $(cat ~/.env | xargs)
dir=$(dirname ${BASH_SOURCE})
log=$dir/deploy.log
format="format:[%h](${repo}%h) %<(6,trunc)%ae: %s"

git fetch
cat $log

L=$(git rev-parse @)
R=$(git rev-parse @{u})

if [ $L != $R ]; then
  $dir/clean.sh
  git status -uno >> $log
  git reset --hard HEAD >> $log
  git pull --force >> $log
  composer install >> $log
  curl -g "https://api.telegram.org/${token}/sendMessage" \
    -d "chat_id=${chat}" \
    -d "parse_mode=markdown" \
    -d "text=[Site](${site}) updated.%0A\
[Deploy Log](${site}:9000/hooks/deploy).%0A\
$(git log --pretty="$format" $L..HEAD | sed -e 's/\.\.//g' -ze 's/\n/%0A/g')" | tee -a $dir/bot.log
fi