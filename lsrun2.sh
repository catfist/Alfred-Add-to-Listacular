#!/bin/bash
LANG=ja_JP.UTF-8
# todo.txt path
todotxt=$(sed "s%~%$HOME%" path)
donetxt=${todotxt%/*}/done.txt
 
IFS=','
if echo "$1" | grep -q '^[0-9]\+,@[due|remind]';then
  read num tag <<< "$1"
  sed -i '' -e "${num}s/@[remind|reminded|due]\(.*\)//g" -e "${num}s/$/ ${tag}/" "$todotxt"
  task=$(sed -n ${num}p  $todotxt | sed 's/^- //')
  echo "New Tag seted: $task"
else
  echo "ERROR: Undifined Tag"
fi
