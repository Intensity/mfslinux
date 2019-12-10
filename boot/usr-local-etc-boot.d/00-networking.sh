#!/bin/sh

devices="$(ifconfig -a |grep '^[^ ]' |awk '{print $1}' |tr -cd 'a-zA-Z0-9\n')"

for i in /proc/sys/net/ipv4/conf /sys/class/net /sys/devices/*/*/*/net
do
  if test -e "$i"/./
  then
    devices="${devices} $(ls $i)"
  fi
done

echo $devices |tr ' ' '\n' | tr -cd 'a-zA-Z0-9\n' |sort |uniq |grep . |grep "^eth" | while read i
do
  ifconfig "$i" up || true
  sleep 1
  dhclient -v "$i"
  sleep 4
done

sleep 2
rmmod ipv6 || true
hostname localhost
netstat -rn
ifconfig -a

true
