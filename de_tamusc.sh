#!/bin/sh

fix() {
  # $1 from
  # $2 to
  echo "### FIX $1 $2"
  cp $1 $2
  sed -e "s/versionsuffix = '-tamusc'//g" -i $2
  git add $2
  git rm $1
} 

for x in `find . -name \*tamusc\*.eb` ; do
  echo $x
  grep tamu $x
  xx=`echo $x | sed 's/-tamusc//'`
  if [ ! -f $xx ] ; then
    fix $x $xx
  else
    delta=`diff $x $xx | grep -c .`
    if [ $delta -eq 4 ] ; then
      fix $x $xx
    else
      echo "### Not overwriting $xx ($delta)"
    fi
  fi
done
# EOF
