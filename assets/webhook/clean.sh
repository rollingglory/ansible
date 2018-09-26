#!/usr/bin/env bash
log=$(dirname ${BASH_SOURCE})/bot.log
chat_id=$(jq ".result.chat.id" <(head -n 1 $log))

for id in $(jq ".result | select(.date > $(date -d '-2 day' +%s)) | .message_id" <$log); do
  curl -w "\n" \
  -g 'https://api.telegram.org/***REMOVED***/deleteMessage' \
  -d "chat_id=$chat_id" \
  -d "message_id=$id"
done

cat $log >> $log.old
rm $log