#!/usr/bin/env bash

KERNEL=${1:-kernel7}

SDCARD_BOOT_PATH=/media/boot
SDCARD_ROOT_PATH=/media/root

# - Build and install modules
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=$SDCARD_ROOT_PATH modules_install

# - Backup old kernel
cp $SDCARD_BOOT_PATH/$KERNEL.img $SDCARD_BOOT_PATH/$KERNEL-backup.img

# - Deploy kernel
cp arch/arm/boot/zImage $SDCARD_BOOT_PATH/$KERNEL.img
# - Deploy dts overlays
cp arch/arm/boot/dts/*.dtb $SDCARD_BOOT_PATH/
cp arch/arm/boot/dts/overlays/*.dtb* $SDCARD_BOOT_PATH/overlays/
cp arch/arm/boot/dts/overlays/README $SDCARD_BOOT_PATH/overlays/

# - Enable tpm within config.txt (only apply the path as long as config.txt did not change)
patch $SDCARD_BOOT_PATH/config.txt -i /tmp/config.txt.patch
