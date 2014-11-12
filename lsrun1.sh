# Add gsed to 'PATH'
PATH=$PATH:/usr/local/bin
todotxt=`cat path | sed "s%~%$HOME%"`
q="$1"
num="${q%%,*}"

task=`sed -n ${num}p $todotxt | sed 's/- //'`
gsed -in "${num}s/^- /x /" $todotxt
echo "done: $task"
