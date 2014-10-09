#!/bin/sh

# add easyconfigs for packages we've successfully built

EBDIR=/software/easybuild # base dir
hostname | grep login00 >& /dev/null
if [ $? -eq 0 ] ; then
  EBDIR="/g/$EBDIR"  # eos is different
fi
EBSWDIR=$EBDIR/software
EBGITDIR=$EBDIR/tamusc/githubs/jack
EBECDIR=$EBGITDIR/easybuild-easyconfigs/easybuild/easyconfigs
TAMUECDIR=$EBGITDIR/tamusc-easyconfigs

for x in 4 5 6 8 ; do
  case $x in 
    4) dir=$EBSWDIR ;;
    5) dir=$EBSWDIR/Core ;;
    6) dir=$EBSWDIR/Compiler ;;
    8) dir=$EBSWDIR/MPI ;;
    *) exit 1 ;;
  esac 
  for y in `find $dir -maxdepth $x -name \*.eb | sort` ; do
    bname=`basename $y`
    bdir=`echo $bname | cut -f 1 -d '-'`
    bflow=`echo $bname | cut -b 1 | tr '[:upper:]' '[:lower:]'`
    #echo $bflow/$bdir/$bname $y
    if [ -f $EBECDIR/$bflow/$bdir/$bname ] ; then
      diff $y $EBECDIR/$bflow/$bdir/$bname >& /dev/null
      if [ $? -eq 0 ] ; then
        echo "# $bname came from $EBECDIR/$bflow/$bdir/$bname" > /dev/null
      else
        echo "EEEEE WARNING: diff $y $EBECDIR/$bflow/$bdir/$bname"
      fi
    else
      if [ ! -d $TAMUECDIR/$bflow/$bdir ] ; then
        mkdir -v $TAMUECDIR/$bflow/$bdir
      fi
      if [ ! -f $TAMUECDIR/$bflow/$bdir/$bname ] ; then
        cp -v $y $TAMUECDIR/$bflow/$bdir
      else 
        diff $y $TAMUECDIR/$bflow/$bdir/$bname >& /dev/null
        if [ $? -ne 0 ] ; then
          echo "TTTTT WARNING: diff $y $TAMUECDIR/$bflow/$bdir/$bname"
        else
          echo "# Already have a copy of $y" > /dev/null
        fi
      fi
    fi
  done
done
# EOF
