IFS=','
read q dat tim <<< "$2"

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
  modst="New tag: $tag"
else
  modst="Input new due date,time"
fi

IFS=$'\n'

cat << EOB
<?xml version="1.0"?>
<items>
EOB

for task in `grep -in "^- .*$q" "$todotxt"`
do
  text=`echo $task | sed -e 's/^[0-9]*:- //' -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' -e "s/'/\&apos;/g" -e 's/"/\&quot;/g'`
  num=`echo $task | sed 's/\(^[0-9]*\):.*/\1/'`
  cat << EOB
  <item uid="Listacular" arg="${num},${tag}" valid="YES" >
  <title>${num}: ${text}</title>
  <subtitle>Make task done</subtitle>
  <subtitle mod="ctrl">${modst}</subtitle>
  </item>
  EOB
done

cat << EOB
</items>
EOB
