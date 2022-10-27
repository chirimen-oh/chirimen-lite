#!/bin/bash -e

on_chroot << EOF
raspi-config nonint do_camera 0
raspi-config nonint do_legacy 0
EOF
