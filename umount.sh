#!/bin/bash
# Configuration
# LVM mountpoint target
echo ${TARGET_VOL_MP:=/dev/VolGroup/lv_root} > /dev/null
# LVM target file format type
echo ${TARGET_VOL_FT:=xfs} > /dev/null
# system mountpoint dir
echo ${SYSTEM_MP_DIR:=/data} > /dev/null

echo "==> UnMounting the logical volume from CentOS"

mount | grep ${SYSTEM_MP_DIR} > /dev/null
if [ $? -eq 0 ]; then
  umount ${SYSTEM_MP_DIR}
else
  echo "==> ${SYSTEM_MP_DIR} directory already unmounted"
fi
