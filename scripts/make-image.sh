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

scripts_dir=`dirname $0`

bash ${scripts_dir}/mount-image.sh $1
bash ${scripts_dir}/update-image.sh $1
bash ${scripts_dir}/unmount-image.sh $1
