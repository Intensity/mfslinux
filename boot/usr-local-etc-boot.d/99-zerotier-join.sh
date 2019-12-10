#!/bin/sh

if test -x /usr/local/sbin/zerotier-one
then

  ZTID="$(dmesg |grep ommand.line|grep ztid= | tail -n 1|sed 's,.* ztid=,,' | sed 's, .*,,' | tr -cd 0-9A-Fa-f | tr A-F a-f)"
  export PATH="${PATH}":/usr/local/sbin:/usr/local/bin

  if test -n "${ZTID}"
  then
    zerotier-cli join "${ZTID}"
    sleep 4
    zerotier-cli info
    sleep 4
    zerotier-cli listnetworks
  else
    echo No ZeroTier ID specified 1>&2
  fi
fi

true
