#!/bin/bash -e

install {files,"${ROOTFS_DIR}"}/usr/local/bin/raspistill

on_chroot <<EOF
raspi-config nonint do_camera 0
EOF
