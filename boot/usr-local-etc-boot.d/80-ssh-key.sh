#!/bin/sh

umask 027
SSH_KEY="$(dmesg |grep ommand.line|grep ssh_key= | tail -n 1|sed 's,.* ssh_key=,,' | sed 's, .*,,')"

if test -n "${SSH_KEY}"
then
  mkdir -p /root/.ssh >/dev/null 2>/dev/null || true
  echo ecdsa-sha2-nistp256 "${SSH_KEY}" root@localhost | tee -a /root/.ssh/authorized_keys
else
  echo No SSH key specified 1>&2
fi

true
