#!/bin/sh
for x in `find . -type d | sort -r` ; do
  latest=`ls $x/*-ictce-6.?.5*.eb 2>/dev/null | sort -n | tail -1`
  if [ "$latest" != "" ] ; then
    echo $latest | grep -e Python -e test >& /dev/null
    if [ $? -ne 0 ] ; then
      eb --try-toolchain=foss,2014c $latest
    fi
  fi
done
# EOF
