#!/usr/bin/bash
# Adapted from LFS (https://www.linuxfromscratch.org/lfs/view/stable/chapter07/kernfs.html)

# Exit if not running as root.
if [ "$EUID" != 0 ]; then
  echo "This script needs to be ran as root."
  exit 1
fi

show_help() {
  echo "Usage: $0 <sysroot> <command>"
  echo "Available commands are:"
  echo "  mount - Mount the virtual kernel file systems"
  echo "  unmount - Unmount the virtual kernel file systems"
  echo "  chroot - Chroot into the sysroot"
  exit 1
}

# Make sure there are two argument passsed
if [ "$#" -ne 2 ]; then
  show_help
fi

# Extract the argument to a variable
ROOT=$(realpath $1)/system-root

mount_kvfs() {
  # Make sure the directories exists
  mkdir -pv $ROOT/{dev,proc,sys,run}

  # Check if we have mounted the virtual kernel file systems already
  mountpoint -q $ROOT/dev

  # Check if last command was successful, if not, we
  # need to mount the virtual kernel file systems
  if [ $? -ne 0 ]; then
    mount -v --bind /dev $ROOT/dev
    mount -v --bind /dev/pts $ROOT/dev/pts
    mount -vt proc proc $ROOT/proc
    mount -vt sysfs sysfs $ROOT/sys
    mount -vt tmpfs tmpfs $ROOT/run

    # In some host systems /dev/shm is a symbolic link to /run/shm
    if [ -h $ROOT/dev/shm ]; then
      mkdir -pv $ROOT/$(readlink $ROOT/dev/shm)
    fi
  fi
}

unmount_kvfs() {
  # Check if we have mounted the virtual kernel file systems already
  mountpoint -q $ROOT/dev

  # Check if last command was successful, if not, we
  # dont have to unmount the virtual kernel file systems
  if [ $? -eq 0 ]; then
    umount -v $ROOT/{dev/pts,dev,proc,sys,run}
  fi
}

# Process the command input
case $2 in
  mount)
    mount_kvfs
    ;;
  umount | unmount)
    unmount_kvfs
    ;;
  chroot)
    mount_kvfs
    chroot $ROOT /usr/bin/env -i HOME=/root TERM="$TERM" PATH=/usr/bin:/usr/sbin /bin/bash --login
    ;;
  *)
    show_help
    ;;
esac

