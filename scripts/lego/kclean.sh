#!/usr/bin/env sh
set -e
[ ! -f "$1" ] && echo "$1 does not exist" && exit 0
filelog="$1"

sort -ru < $filelog | while IFS= read -r line
do
  method=$(echo $line | cut -d':' -f 2)
  path=$(echo $line | cut -d':' -f 3)
  if [ "$method" = "C" ]
  then
    [ -f "$path" ] && echo "CLEAN    $path" && rm -f "$path"
  elif [ "$method" = "U" ]
  then
    bpath="$(dirname $path)/.$(basename $path).lego.updated"
    [ -f "$bpath" ] && echo "ROLLBACK $path" && mv -f "$bpath" "$path"
  fi
done
echo "CLEAN    ${filelog}"
rm -f ${filelog}
