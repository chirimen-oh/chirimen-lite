#!/bin/bash -e

echo dtoverlay=dwc2 >> "${ROOTFS_DIR}/boot/config.txt"
sed -i '1{/ modules-load=/!s|$| modules-load=dwc2,g_serial|}' "${ROOTFS_DIR}/boot/cmdline.txt"

on_chroot << EOF
systemctl enable getty@ttyGS0.service
EOF
