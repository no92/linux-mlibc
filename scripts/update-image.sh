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
system_root="${build_root}/system-root"

rsync -a ${system_root}/boot ${image_dir}
rsync -a ${system_root}/home ${image_dir}
rsync -a ${system_root}/root ${image_dir}
rsync -a --delete ${system_root}/bin ${image_dir}
rsync -a --delete ${system_root}/dev ${image_dir}
rsync -a --delete ${system_root}/etc ${image_dir}
rsync -a --delete ${system_root}/lib ${image_dir}
rsync -a --delete ${system_root}/media ${image_dir}
rsync -a --delete ${system_root}/mnt ${image_dir}
rsync -a --delete ${system_root}/opt ${image_dir}
rsync -a --delete ${system_root}/proc ${image_dir}
rsync -a --delete ${system_root}/run ${image_dir}
rsync -a --delete ${system_root}/sbin ${image_dir}
rsync -a --delete ${system_root}/srv ${image_dir}
rsync -a --delete ${system_root}/sys ${image_dir}
rsync -a --delete ${system_root}/tmp ${image_dir}
rsync -a --delete ${system_root}/usr ${image_dir}
rsync -a --delete ${system_root}/var ${image_dir}

