#!/bin/bash
LANG=ja_JP.UTF-8
# todo.txt path
todotxt=$(sed "s%~%$HOME%" path)
donetxt=${todotxt%/*}/done.txt
 
IFS=','
read type pre task <<< "$2"

l1=$(tail -c 1 $todotxt)
if [ -n "$l1" ];then
echo "" >> $todotxt
fi
echo -n "${pre}${task}" >> $todotxt

echo "${type}: ${task}"
