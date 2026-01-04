#!/bin/bash -e

install -v -m 644 {files,"${ROOTFS_DIR}"}/etc/profile.d/n.sh
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/myApp"
install -v -o 1000 -g 1000 -m 644 {files,"${ROOTFS_DIR}/home/${FIRST_USER_NAME}"}/myApp/package.json

mount --bind /etc/ssl/certs "${ROOTFS_DIR}/etc/ssl/certs"

on_chroot << EOF
install <(curl -sL https://raw.githubusercontent.com/tj/n/master/bin/n) /usr/local/bin/n
. /etc/profile.d/n.sh
n --arch armv6l lts

sudo -u#1000 npm config set prefix '/home/${FIRST_USER_NAME}/.local'
sudo -u#1000 npm install -g forever
sudo -u#1000 npm --prefix '/home/${FIRST_USER_NAME}/myApp' install
sudo -u#1000 ln -fsv myApp/node_modules '/home/${FIRST_USER_NAME}/node_modules'
EOF
