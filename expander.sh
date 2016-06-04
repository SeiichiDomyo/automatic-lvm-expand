#!/bin/bash
###############################################################
# Code by Jioh L. Jung (ziozzang@gmail.com)
# Modified by Seiichi Domyo (seiichi.do@gmail.com)
###############################################################
# Configuration
# Target Device
# - Raw disk device. you can specify one device or use wildcard
TARGET_DEVICE="/dev/sd?"
# LVM group
echo ${TARGET_VOL_GRP:=VolGroup} > /dev/null
# LVM mountpoint target
echo ${TARGET_VOL_MP:=/dev/VolGroup/lv_root} > /dev/null
###############################################################
 
for disk in ${TARGET_DEVICE}
do
  target_disk=${disk}1
  # Check Already Partioned
  if [[ -e ${target_disk} ]]; then
    echo "==> ${target_disk} partition already exist"
    continue
  else
    echo "==> ${disk} is not partioned"
    echo "==> Create MBR label"
    parted -s $disk  mklabel msdos
    ncyl=$(parted $disk unit cyl print  | sed -n 's/.*: \([0-9]*\)cyl/\1/p')
    if [[ $ncyl != [0-9]* ]]; then
      echo "disk $disk has invalid cylinders number: $ncyl"
      continue
    fi
    echo "==> create primary parition 1 with $ncyl cylinders"
    parted -a optimal $disk mkpart primary 0cyl ${ncyl}cyl
    echo "==> set partition $partno to type: lvm "
    parted $disk set 1 lvm on
    partprobe > /dev/null 2>&1
    pvcreate -y -ff ${target_disk}
    echo "==> created PV ${target_disk} as LVM Partition"

    # Check Already Volume Group
    vgscan | grep ${TARGET_VOL_GRP}
    if [ $? -ne 0 ]; then
    	echo "==> Create VG ${TARGET_VOL_GRP}"
        vgcreate -y -f ${TARGET_VOL_GRP} ${target_disk} 
    else
        echo "==> Extend Volume ${TARGET_VOL_GRP}"
        vgextend ${TARGET_VOL_GRP} ${target_disk}
    fi

    # Check Already Logical Volume
    lvscan | grep ${TARGET_VOL_MP}
    if [ $? -ne 0 ]; then
        echo "==> Create LV ${TARGET_VOL_MP}"
        lvcreate -n ${TARGET_VOL_MP} -l 100%FREE ${TARGET_VOL_GRP}
    else
        echo "==> Extend Volume Partition to ${TARGET_VOL_MP}"
        lvextend ${TARGET_VOL_MP} ${target_disk}
    fi
  fi
done
echo "==> Done"
