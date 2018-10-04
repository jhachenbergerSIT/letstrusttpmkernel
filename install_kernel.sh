SDCARD_BOOT_PATH=/media/boot/
SDCARD_ROOT_PATH=/media/root/

# - Build and install modules
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=$SDCARD_ROOT_PATH modules_install

# - Backup old kernel
cp $SDCARD_BOOT_PATH/kernel.img $SDCARD_BOOT_PATH/kernel-backup.img

# - Deploy kernel
cp arch/arm/boot/zImage $SDCARD_BOOT_PATH/kernel.img
cp arch/arm/boot/zImage $SDCARD_BOOT_PATH/kernel7.img
# - Deploy dts overlays
cp arch/arm/boot/dts/*.dtb $SDCARD_BOOT_PATH/
cp arch/arm/boot/dts/overlays/*.dtb* $SDCARD_BOOT_PATH/overlays/
cp arch/arm/boot/dts/overlays/README $SDCARD_BOOT_PATH/overlays/

# - Enable tpm within config.txt (only apply the path as long as config.txt did not change)
md5sum -c /tmp/config.txt.md5sum && patch $SDCARD_BOOT_PATH/config.txt < /tmp/config.patch
