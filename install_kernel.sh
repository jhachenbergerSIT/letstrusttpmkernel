#!/usr/bin/env bash

KERNEL=${1:-kernel8}

SDCARD_BOOT_PATH=/media/boot
SDCARD_ROOT_PATH=/media/root

# - Build and install modules
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_PATH=$SDCARD_ROOT_PATH modules_install

# - Backup old kernel
cp $SDCARD_BOOT_PATH/$KERNEL.img $SDCARD_BOOT_PATH/$KERNEL-backup.img

# - Deploy kernel
cp arch/arm64/boot/Image $SDCARD_BOOT_PATH/$KERNEL.img
# - Deploy dts overlays
cp "arch/arm64/boot/dts/broadcom/"*.dtb $SDCARD_BOOT_PATH/
cp "arch/arm64/boot/dts/overlays/"*.dtb* $SDCARD_BOOT_PATH/overlays/
cp arch/arm64/boot/dts/overlays/README $SDCARD_BOOT_PATH/overlays/

# - Enable tpm within config.txt (only apply the path as long as config.txt did not change)
#patch $SDCARD_BOOT_PATH/config.txt -i /tmp/config.txt.patch
