#!/bin/bash -e

echo dtoverlay=dwc2 >> "${ROOTFS_DIR}/boot/config.txt"
install -m 644 {files,${ROOTFS_DIR}}/etc/modprobe.d/g_acm_ms.conf
install -m 644 {files,${ROOTFS_DIR}}/etc/modules-load.d/g_acm_ms.conf

on_chroot << EOF
systemctl enable getty@ttyGS0.service
EOF
