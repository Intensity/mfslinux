#!/bin/sh

if test -d /usr/local/etc/boot.d/./
then
  for i in /usr/local/etc/boot.d/*.sh
  do
    if test -f "$i" && test -x "$i"
    then
      sh "$i"
    fi
  done
fi
