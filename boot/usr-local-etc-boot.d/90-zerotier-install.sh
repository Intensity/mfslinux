#!/bin/sh

if test -x /usr/local/sbin/zerotier-one
then
  umask 027
  mkdir -p /var/lib/zerotier-one/ || true
  modprobe tun || true
  sleep 2
  sync
  (export PATH="${PATH}":/usr/local/sbin:/usr/local/bin; zerotier-one -d </dev/null >>/var/log/zerotier.1 2>>/var/log/zerotier.2 &)
  sleep 12
fi

true
