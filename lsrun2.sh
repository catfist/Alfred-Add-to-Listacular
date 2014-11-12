# Add gsed to 'PATH'
PATH=$PATH:/usr/local/bin
todotxt=`cat path | sed "s%~%$HOME%"`
IFS=','

if echo "$1" | grep -q '^[0-9]\+,@[due|remind]';then
  read num tag <<< "$1"
  gsed -i -e "${num}s/@[remind|reminded|due]\(.*\)//g" -e "${num}s/$/ ${tag}/" $todotxt
  task=`sed -n ${num}p  $todotxt | sed 's/^- //'`
  echo "New Tag seted: $task"
else
  echo "ERROR: Undifined Tag"
fi
