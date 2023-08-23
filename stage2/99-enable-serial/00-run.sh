#!/bin/bash -e

echo dtoverlay=dwc2 >> "${ROOTFS_DIR}/boot/config.txt"
install -m 644 {files,"${ROOTFS_DIR}"}/etc/modules-load.d/g_serial.conf

on_chroot << EOF
systemctl enable getty@ttyGS0.service
EOF
