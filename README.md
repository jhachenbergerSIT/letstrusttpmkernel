# General

This Docker image is meant to be used to build a Let's Trust TPM enabled raspberry Pi Linux Kernel.

# Installation

First of all, build the image:

    sudo docker build -t rpi_tpm_kernel_builder .

Afterwards adapt the paths to which your system has mounted the SD card partitions (you can find them using `lsblk`):

    SDCARD_BOOT_PATH=/media/user/boot
    SDCARD_ROOT_PATH=/media/user/root

and run

    sudo docker run -it --volume $SDCARD_BOOT_PATH:/media/boot --volume $SDCARD_ROOT_PATH:/media/root rpi_tpm_kernel_builder
