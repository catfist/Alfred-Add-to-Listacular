todotxt=`cat path | sed "s%~%$HOME%"`
IFS=','
read type pre task <<< "$1"

l1=`tail -c 1 $todotxt`
if [ -n "$l1" ];then
echo "" >> $todotxt
fi
echo -n "${pre}${task}" >> $todotxt

echo "${type}: ${task}"