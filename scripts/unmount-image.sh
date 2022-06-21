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
image_dir="${build_root}/image-dir"
loopback_file="${build_root}/loopback"

if [ ! -f ${loopback_file} ]; then
  echo "The image has not been mounted"
  exit 1
fi

umount -q ${image_dir} || true
losetup -d `cat ${loopback_file}`
rm -rf ${image_dir} ${loopback_file}
