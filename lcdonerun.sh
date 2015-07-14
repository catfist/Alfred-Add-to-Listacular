#!/bin/bash
LANG=ja_JP.UTF-8
# todo.txt path
todotxt=$(sed "s%~%$HOME%" path)
donetxt=${todotxt%/*}/done.txt
 
echo "Archived:"
sed -n 's/^x //gp' "$todotxt" # echo list of done task
grep '^x ' "$todotxt" | sed 's/@[due|remind])]*)//g' >> "$donetxt" # write done tasks to donetxt without tags
sed -i '' '/^x /d' "$todotxt" # delete done tasks from todotxt
sed -n '$p' "$todotxt" | (sed -i '' '$d' "$todotxt"; xargs echo -n >> "$todotxt") # delete linebreak of last line from todotxt
