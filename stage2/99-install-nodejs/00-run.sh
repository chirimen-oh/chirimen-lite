#!/bin/bash -e

install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/myApp"
install -v -o 1000 -g 1000 -m 644 {files,"${ROOTFS_DIR}/home/${FIRST_USER_NAME}"}/myApp/package.json

mount --bind /etc/ssl/certs "${ROOTFS_DIR}/etc/ssl/certs"

on_chroot << EOF
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get -o Acquire::Retries=3 install -y nodejs

sudo -u#1000 npm config set prefix '/home/${FIRST_USER_NAME}/.local'
sudo -u#1000 npm install -g forever jiti
sudo -u#1000 npm --prefix '/home/${FIRST_USER_NAME}/myApp' install
sudo -u#1000 ln -fsv myApp/node_modules '/home/${FIRST_USER_NAME}/node_modules'
EOF
