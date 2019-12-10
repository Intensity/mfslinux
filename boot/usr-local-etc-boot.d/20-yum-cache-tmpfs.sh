#!/bin/sh

umask 022
yum clean all
cd /var/cache
(cd yum && tar cf ../yum.tar .)
rm -rf yum
mkdir yum
cd
mount -v -t tmpfs tmpfs /var/cache/yum
(cd /var/cache/yum/./ && tar xpkf ../yum.tar && rm -f ../yum.tar)
true
