#!/usr/bin/env bash

if [ $# -eq 0 ]
  then echo "Not for GET"
  exit 0
fi

findrepo() {
  find ~ -maxdepth 2 -name .git -exec sh -c \
    "git -C {} remote get-url origin | grep $@ && dirname {}" \;
}

webhook=$(dirname ${BASH_SOURCE})
path=$(findrepo $1 | tail -n1)
repo=$(findrepo $1 | head -n1 | sed 's/rollingglory:.*@//')
slug=$(basename $repo)
log=$webhook/$slug.log
format="format:[%h](${repo}%h) %<(6,trunc)%ae: %s"

export $(cat $path/.env | xargs)

cd $path
git fetch

L=$(git rev-parse @)
R=$(git rev-parse @{u})

if [ $L != $R ]; then
  $webhook/clean.sh
  git reset --hard HEAD
  git pull --force
  curl -g "https://api.telegram.org/${token}/sendMessage" \
    -d "chat_id=${chat}" \
    -d "parse_mode=markdown" \
    -d "text=[Repository]($repo) [Site]($site) updated.%0A%0A\
$(git log --pretty="$format" $L..HEAD | sed -e 's/\.\.//g' -ze 's/\n/%0A/g')" >> $webhook/bot.log
fi