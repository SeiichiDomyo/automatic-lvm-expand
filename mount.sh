#!/bin/bash
###############################################################
# Code by Seiichi Domyo (seiichi.do@gmail.com)
###############################################################
# Configuration
# LVM mountpoint target
echo ${TARGET_VOL_MP:=/dev/VolGroup/lv_root} > /dev/null
# LVM target file format type
echo ${TARGET_VOL_FT:=xfs} > /dev/null
# system mountpoint dir
echo ${SYSTEM_MP_DIR:=/data} > /dev/null

echo "==> Mounting the logical volume into CentOS"

mount | grep ${SYSTEM_MP_DIR} > /dev/null
if [ $? -ne 0 ]; then
  mkfs -t ${TARGET_VOL_FT} -i size=512 ${TARGET_VOL_MP}
  mkdir -p ${SYSTEM_MP_DIR}
  echo "${TARGET_VOL_MP} ${SYSTEM_MP_DIR} ${TARGET_VOL_FT} noatime,inode64 0 0" >>/etc/fstab
  mount ${SYSTEM_MP_DIR}
else
  echo "==> ${SYSTEM_MP_DIR} directory already mounted"
fi
