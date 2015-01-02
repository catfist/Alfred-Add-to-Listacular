num="${2%%,*}"
task=`sed -n ${num}p $todotxt | sed 's/- //'`
gsed -in "${num}s/^- /x /" $todotxt
echo "done: $task"
