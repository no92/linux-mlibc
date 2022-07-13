#!/usr/bin/env bash

set -e

if [ "$EUID" != 0 ]; then
  echo "This script needs to be ran as root"
  exit 1
fi

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 [build root]"
  exit 1
fi

build_root=$1
scripts_dir=`dirname $0`
image_path="${build_root}/image"
image_dir="${build_root}/image-dir"
loopback_file="${build_root}/loopback"
system_root="${build_root}/system-root"

if [ ! -f ${image_path} ]; then
  # Calculate the needed image size + around 512M headroom for the file system and user
  real_image_size=`du -bs ${system_root} | cut -f1`
  image_size=`expr ${real_image_size} + 1024 \* 1024 \* 512`

  sudo -u ${SUDO_USER} qemu-img create -f qcow2 -o preallocation=metadata ${image_path} 40G
  create_fs=1
fi

if [ -f ${loopback_file} ]; then
  umount -q ${image_dir} || true
  losetup -d `cat ${loopback_file}`
  rm ${loopback_file}
fi

if [ -d ${image_dir} ]; then
  rm -rf ${image_dir}
fi

loopback=`losetup -Pf --show ${image_path}`

echo ${loopback} > ${loopback_file}

if [ "${create_fs}" == "1" ]; then
  parted -s ${image_path} mklabel gpt
  parted -s ${image_path} mkpart primary ext4 2048s 100%
  partprobe ${loopback}
  mkfs.ext4 ${loopback}p1
fi

sudo -u ${SUDO_USER} mkdir -p ${image_dir}
mount ${loopback}p1 ${image_dir}
mkdir -p ${image_dir}/boot
cp ${build_root}/tools/host-limine/share/limine/limine.sys ${image_dir}/boot
cp ${scripts_dir}/limine.cfg ${image_dir}/boot
# In the future when we generate an initrd and we have eudev we can use this
# instead of hardcoding /dev/sda1 in the Limine config!
# sed -i "s/@UUID@/`blkid -o value -s PARTUUID ${loopback}p1`/" ${image_dir}/boot/limine.cfg
