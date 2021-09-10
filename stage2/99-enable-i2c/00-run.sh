#!/bin/bash -e

on_chroot << EOF
raspi-config nonint do_i2c 0
EOF
