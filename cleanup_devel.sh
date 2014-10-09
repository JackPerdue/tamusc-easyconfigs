#!/bin/sh

# house cleaning

EBDIR=/software/easybuild # base dir
hostname | grep login00 >& /dev/null
if [ $? -eq 0 ] ; then
  EBDIR="/g/$EBDIR"  # eos is different
fi
EBSWDIR=$EBDIR/software
EBGITDIR=$EBDIR/tamusc/githubs/jack
EBECDIR=$EBGITDIR/easybuild-easyconfigs/easybuild/easyconfigs
TAMUECDIR=$EBGITDIR/tamusc-easyconfigs
DEVDIR=$EBDIR/tamusc/easybuild/easyconfigs

for y in `ls $DEVDIR/*.eb` ; do
  bname=`basename $y`
  bdir=`echo $bname | cut -f 1 -d '-'`
  bflow=`echo $bname | cut -b 1 | tr '[:upper:]' '[:lower:]'`
  for x in $EBECDIR $TAMUECDIR ; do
    if [ -f $x/$bflow/$bdir/$bname ] ; then
      diff $y $x/$bflow/$bdir/$bname >& /dev/null
      if [ $? -eq 0 ] ; then
        #echo "Found matching $y in $x/$bflow/$bdir/$bname"
        rm -vf $y
      else
        echo "### diff $y $x/$bflow/$bdir/$bname"
      fi
    fi 
  done
done
# EOF
