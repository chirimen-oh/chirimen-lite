#!/bin/bash -e

install -m 644 {files,"${ROOTFS_DIR}"}/etc/profile.d/n.sh

mount --bind /etc/ssl/certs "${ROOTFS_DIR}/etc/ssl/certs"

on_chroot << EOF
install <(curl -sL https://raw.githubusercontent.com/tj/n/master/bin/n) /usr/local/bin/n
. /etc/profile.d/n.sh
n --arch armv6l lts
EOF
