#!/bin/bash
LANG=ja_JP.UTF-8
# todo.txt path
todotxt=$(sed "s%~%$HOME%" path)
 
num="${1%%,*}"
task="$(sed -n "${num}"p "$todotxt" | sed 's/- //')"
sed -i '' "${num}s/^- /x /" "$todotxt"
echo "done: $task"
