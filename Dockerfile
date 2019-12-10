FROM debian:buster

RUN umask 022 && apt-get update && apt-get -y dist-upgrade && apt-get -y install genisoimage syslinux-utils syslinux-common isolinux xz-utils wget rpm2cpio cpio binutils && \
    mkdir -p /usr/local/src/mfslinux && \
    cd /usr/local/src/mfslinux && \
    mkdir -p work/iso/isolinux work/image work/kernel && \
    cp -p /usr/lib/ISOLINUX/isolinux.bin /usr/lib/syslinux/modules/bios/ldlinux.c32 work/iso/isolinux/ && \
    cd work/image && \
    wget -nv https://download.openvz.org/template/precreated/centos-7-x86_64-minimal.tar.gz && \
    tar xzpkf centos-7-x86_64-minimal.tar.gz && \
    rm centos-7-x86_64-minimal.tar.gz && \
    rm -f etc/resolv.conf && \
    echo nameserver 8.8.8.8 | tee etc/resolv.conf && \
    (mkdir -p boot/ || true) && \
    chroot . /bin/sh -c "yum update -y" && \
    tar -C /dev -cf - random urandom null zero | tar -C /usr/local/src/mfslinux/work/image/dev -xpf - && \
    chroot . /bin/sh -c "yum update -y" && \
    cd ../kernel && \
    apt-get download linux-image-4.19.0-6-amd64-unsigned && \
    ar x linux-image-4.19.0-6-amd64-unsigned*amd64.deb && \
    cat data.tar.xz | xz -d | tar -xpkf - && \
    mv -f lib/modules/4.*/ ../image/usr/lib/modules/ && \
    mv -f boot/* ../image/boot/ && \
    cd ../image && \
    rm -r ../kernel/ && \
    ln boot/vmlinuz-4.19.0-6-amd64 ../iso/isolinux/vmlinuz && \
    chroot . /bin/sh -c "depmod -a" && \
    chroot . /bin/sh -c "rm -f /etc/nsswitch.conf.bak && mv -f /etc/nsswitch.conf.rpmnew /etc/nsswitch.conf" && \
    chroot . /bin/sh -c "mv -f /etc/ssh/sshd_config.rpmnew /etc/ssh/sshd_config" && \
    chroot . /bin/sh -c "mkdir -p /usr/local/etc /usr/local/sbin || true" && \
    chroot . /bin/sh -c "perl -pi -e '/BOOTUP=color/ and s,color,verbose,' /etc/sysconfig/init" && \
    chroot . /bin/sh -c "perl -pi -e '/^alias / and s,^,#,' /root/.[a-z]*rc" && \
    chroot . /bin/sh -c "echo diskspacecheck=0 | tee -a /etc/yum.conf" && \
    rm -f ./etc/*- && \
    chroot . /bin/sh -c "yum clean all"
COPY . /usr/local/src/mfslinux-staging
RUN umask 022 && tar -C /usr/local/src/mfslinux-staging/ -cf - . | tar -C /usr/local/src/mfslinux/ -xpkf - && \
    rm -r /usr/local/src/mfslinux-staging/ && \
    sh -c "if test -e /usr/local/src/mfslinux/zerotier-one; then mv -f /usr/local/src/mfslinux/zerotier-one /usr/local/src/mfslinux/work/image/usr/local/sbin/zerotier-one && ln -s zerotier-one /usr/local/src/mfslinux/work/image/usr/local/sbin/zerotier-cli; else true; fi" || true && \
    mv -i /usr/local/src/mfslinux/boot/usr-local-etc-boot.d /usr/local/src/mfslinux/work/image/usr/local/etc/boot.d && \
    mv -i /usr/local/src/mfslinux/boot/etc/boot.d /usr/local/src/mfslinux/work/image/etc/boot.d && \
    cd /usr/local/src/mfslinux/work/image/ && \
    cat ../../boot/etc/rc.local.append | tee -a etc/rc.d/rc.local && \
    rm ../../boot/etc/rc.local.append && \
    chmod ugo+rx etc/rc.d/rc.local && \
    chroot . /bin/sh -c "perl -pi -e 's,GSSAPIAuthentication yes,GSSAPIAuthentication no,; /^AcceptEnv/ and s,^,#,; /^Subsystem/ and s,^,#,; s,X11Forwarding yes,X11Forwarding no,' /etc/ssh/sshd_config" && \
    chroot . /bin/sh -c "chmod -R ugo+rx /etc/boot.d /usr/local/etc/boot.d" && \
    chroot . /bin/sh -c "yum install -y net-tools dhclient syslinux parted cryptsetup" && \
    cp -a ../../isolinux/boot.txt ../../isolinux/isolinux.cfg ../iso/isolinux/ && \
    echo 'ztid=8056c2e21c000001 ssh_key=add_ecdsa_key_here' | tee -a ../iso/isolinux/isolinux.cfg >/dev/null && \
    find . -print0 | cpio -o -0 -H newc | gzip -9 > ../iso/isolinux/initramfs.igz && \
    cd ../../ && \
    genisoimage  -r -T -J -iso-level 2 -V mfslinux -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o work/mfslinux.iso work/iso && \
    isohybrid --verbose --partok work/mfslinux.iso
