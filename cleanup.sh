#!/bin/sh

TMP=/tmp/cu$$.tmp
JKPECDIR=/software/easybuild/tamusc/githubs/jack/easybuild-easyconfigs/easybuild/easyconfigs # what to clean
EBECDIR=~/github/easybuild-easyconfigs.develop/easybuild/easyconfigs/ # clean copy
TAMUECDIR=/software/easybuild/tamusc/githubs/jack/tamusc-easyconfigs # move stuff to here

cd $JKPECDIR
for x in `diff -q -r . $EBECDIR | grep Only | grep -v '\.git' | grep '.eb' | cut -f 3,4 -d ' ' | sed 's,^\./,,' | sed 's,: ,/,'` ; do
  if [ -f $TAMUECDIR/$x ] ; then
    diff -q $x $TAMUECDIR/$x
    if [ $? -eq 0 ] ; then
      echo "$x is the same as $TAMUECDIR/$x"
      git rm $x
    else
      "### DIFF: diff $x $TAMUECDIR/$x"
    fi
  else
    cp $x $TAMUECDIR/$x
    #git rm $x
  fi
done
# EOF
