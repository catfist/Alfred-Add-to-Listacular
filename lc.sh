#!/bin/bash
LANG=ja_JP.UTF-8
# Add gsed to 'PATH'
PATH=$PATH:/usr/local/bin
# todo.txt path
todotxt=`cat path | sed "s%~%$HOME%"`
donetxt=${todotxt%/*}/done.txt

case $1 in
lcinput )
q="$2"

IFS=','
set -- $q

tsk="$1"
dat="$2"
tim="$3"

if echo "$q" | grep -q @n; then
  type=Note
  pre=""
  task=`echo "${tsk}" | sed 's/@n//'`
else
  type=Task
  pre="- "
  if echo "${dat}${tim}" | grep -q [0-9]; then
      [ `echo "$dat" | grep "^+[0-9]\+$"` ];RP=$?
      [ `echo "$dat" | grep "^[0-9]\{1,2\}$"` ];RD=$?
      [ `echo "$dat" | grep "^[0-9]\{1,2\}-[0-9]\{1,2\}$"` ];RM=$?
      [ `echo "$dat" | grep "^[0-9]\{4\}-[0-9]\{1,2\}-[0-9]\{1,2\}$"` ];RY=$?
      case "${RP}${RD}${RM}${RY}" in
        0111)
          dat=`date -v${dat}d '+%Y-%m-%d'`
        ;;
        1011)
          dat=`echo -n 0$dat | tail -c 2`
          if [ "$dat" -lt `date '+%d'` ];then
            month=`date -v+1m '+%Y-%m'`
          else
            month=`date '+%Y-%m'`
          fi
          dat="$month"-"$dat"
        ;;
        1101)
          dat=`expr "0${dat}" : '[0-9]*\([0-9]\{2\}\)-'`-`echo $dat | sed -e 's/^[0-9]*-//' -e 's/^/0/' | tail -c 3`
          if [ `echo "$dat" | tr -dc [0-9]` -lt `date '+%m%d'` ];then
            year=`date -v+1y '+%Y'`
          else
            year=`date '+%Y'`
          fi
          dat="$year"-"$dat"
        ;;
        1110)
          dat=`echo "${dat}" | head -c 4`-`echo "$dat" | sed -e 's/^[0-9]*-[0-9]\{1,2\}-//' -e 's/^/0/' | tail -c 3`-`echo ${dat} | sed -e 's/^[0-9]*-[0-9]*-//' -e 's/^/0/' | tail -c 3`
        ;;
      esac
    if [ -z "${tim}" ]; then
      tag="@due(${dat} 23:59)"
    else
      if echo "${tim}" | grep -q "^[0-9]\{1,2\}$";then
        tim=`echo "0${tim}:00" | tail -c 6`
      fi
      if echo "${tim}" | grep -q "^[0-9]\{3,4\}$";then
        tim=`echo 0${tim}| tail -c 5 | sed 's/\(..\)$/:\1/'`
      fi
      if echo "$tim" | grep -q '^[0-9]*[mh]$';then
        tim=`echo $tim | tr h,m H,M`
        tim=`date -v+${tim} '+%H:%M'`
      fi
      if [ -z "${dat}" ]; then
        dat=`date '+%Y-%m-%d'`
      fi
      tag="@remind(${dat} ${tim})"
    fi
  else
    tag=""
  fi
fi

add=`echo "${tsk} ${tag}" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' -e "s/'/\&apos;/g" -e 's/"/\&quot;/g'`
cat << EOB
<?xml version="1.0"?>
<items>
<item uid="Listacular" arg="${type},${pre},${add}" valid="YES" >
<title>${type}: ${add}</title>
</item>
</items>
EOB
;;

lcrun )
IFS=','
read type pre task <<< "$2"

l1=`tail -c 1 "$todotxt"`
if [ -n "$l1" ];then
echo "" >> "$todotxt"
fi
echo -n "${pre}${task}" >> "$todotxt"

echo "${type}: ${task}"
;;

lsinput )
q="$2"

IFS=','
read txt dat tim <<< "$q"

if test `echo "${dat}${tim}" | grep [0-9]`; then
    [ `echo "$dat" | grep "^+[0-9]\+$"` ];RP=$?
    [ `echo "$dat" | grep "^[0-9]\{1,2\}$"` ];RD=$?
    [ `echo "$dat" | grep "^[0-9]\{1,2\}-[0-9]\{1,2\}$"` ];RM=$?
    [ `echo "$dat" | grep "^[0-9]\{4\}-[0-9]\{1,2\}-[0-9]\{1,2\}$"` ];RY=$?
    case "${RP}${RD}${RM}${RY}" in
      0111)
        dat=`date -v${dat}d '+%Y-%m-%d'`
      ;;
      1011)
        dat=`echo -n 0$dat | tail -c 2`
        if [ "$dat" -lt `date '+%d'` ];then
          month=`date -v+1m '+%Y-%m'`
        else
          month=`date '+%Y-%m'`
        fi
        dat="$month"-"$dat"
      ;;
      1101)
        dat=`expr "0${dat}" : '[0-9]*\([0-9]\{2\}\)-'`-`echo $dat | sed -e 's/^[0-9]*-//' -e 's/^/0/' | tail -c 3`
        if [ `echo "$dat" | tr -dc [0-9]` -lt `date '+%m%d'` ];then
          year=`date -v+1y '+%Y'`
        else
          year=`date '+%Y'`
        fi
        dat="$year"-"$dat"
      ;;
      1110)
        dat=`echo "${dat}" | head -c 4`-`echo "$dat" | sed -e 's/^[0-9]*-[0-9]\{1,2\}-//' -e 's/^/0/' | tail -c 3`-`echo ${dat} | sed -e 's/^[0-9]*-[0-9]*-//' -e 's/^/0/' | tail -c 3`
      ;;
    esac
  if [ -z "${tim}" ]; then
    tag="@due(${dat} 23:59)"
  else
    if echo "${tim}" | grep -q "^[0-9]\{1,2\}$";then
      tim=`echo "0${tim}:00" | tail -c 6`
    fi
    if echo "${tim}" | grep -q "^[0-9]\{3,4\}$";then
      tim=`echo 0${tim}| tail -c 5 | sed 's/\(..\)$/:\1/'`
    fi
    if echo "$tim" | grep -q '^[0-9]*[mh]$';then
      tim=`echo $tim | tr h,m H,M`
      tim=`date -v+${tim} '+%H:%M'`
    fi
    if [ -z "${dat}" ]; then
      dat=`date '+%Y-%m-%d'`
    fi
    tag="@remind(${dat} ${tim})"
  fi
  modst="Add new Tag"
else
  modst="Input new due date,time"
fi

cat << EOB
<?xml version="1.0"?>
<items>
EOB

IFS=$'\n'
for task in `grep -in "^- .*$txt" "$todotxt" `
do
  bdy=`echo "$task" | sed -e 's/^[0-9]*:- //'`
  if [ -n "$tag" ];then
    bdy=`echo "$bdy" | gsed -e "s/@[due|remind|reminded][^)]*)/$tag/g" -e 's/^/[NewTag] /'`
  fi
  bdy=`echo "$bdy" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' -e "s/'/\&apos;/g" -e 's/"/\&quot;/g'`
  num=`echo "$task" | sed 's/\(^[0-9]*\):.*/\1/'`
  cat << EOB
<item uid="Listacular" arg="${num},${tag}" valid="YES">
<title>${bdy}</title>
<subtitle>Make task done</subtitle>
<subtitle mod="ctrl">${modst}</subtitle>
</item>
EOB
done

cat << EOB
</items>
EOB
;;

lsrun1 )
q="$2"
num="${q%%,*}"

task=`sed -n ${num}p "$todotxt" | sed 's/- //'`
gsed -in "${num}s/^- /x /" "$todotxt"
echo "done: $task"
;;

lsrun2 )
IFS=','
q="$2"
if echo "$q" | grep -q '^[0-9]\+,@[due|remind]';then
  read num tag <<< "$q"
  gsed -i -e "${num}s/@[remind|reminded|due]\(.*\)//g" -e "${num}s/$/ ${tag}/" "$todotxt"
  task=`sed -n ${num}p  "$todotxt" | sed 's/^- //'`
  echo "New Tag seted: $task"
else
  echo "ERROR: Undifined Tag"
fi
;;

lcdonerun )
echo "Archived:"
gsed -n 's/^x //gp' "$todotxt"
grep '^x ' "$todotxt" | gsed 's/@[due|remind][^)]*)//g' >> "$donetxt"
gsed -i '/^x /d' "$todotxt"
gsed -n '$p' "$donetxt" | (gsed -i '$d' "$donetxt"; xargs echo -n >> "$donetxt")
gsed -n '$p' "$todotxt" | (gsed -i '$d' "$todotxt"; xargs echo -n >> "$todotxt")
;;

esac