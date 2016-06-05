#!/bin/bash

# set variables for centos
export TARGET_VOL_GRP="centos"

export TARGET_VOL_MP="/dev/${TARGET_VOL_GRP}/log"
export TARGET_VOL_FT="ext4"
export TARGET_DEVICE="/dev/sdb"
export SYSTEM_MP_DIR="/log"
./umount.sh

export TARGET_VOL_MP="/dev/${TARGET_VOL_GRP}/data"
export TARGET_VOL_FT="xfs"
export TARGET_DEVICE="/dev/sd?"
export SYSTEM_MP_DIR="/data"
./umount.sh

