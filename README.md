# General

This Docker image is meant to be used to build a Linux Kernel for the Raspberry Pi with TPM support (especially LetsTrusts TPM). The steps involved have been extracted from [letstrust.de - Howto Enable TPM Support on a Raspberry PI (0, 0W, 1, 2, 3, 3b+) and make it work with the LetsTrust TPM](https://letstrust.de/archives/9-Howto-Enable-TPM-Support-on-a-Raspberry-PI-0,-0W,-1,-2,-3,-3b+-and-make-it-work-with-the-LetsTrust-TPM.html).

# Requirements

This projects aims to enhance already running Raspberry Pis with TPM. Hence, the runtime Docker container will try to deploy the new kernel to an RPi ready SD card (eg. with a Raspbian stored on it).
Thus, we expect the presence of two volume mounts: root and boot. This is how a typical Raspberry Pi SD card is formatted.

# Installation

Build the Docker image:

    sudo docker build -t rpi_tpm_kernel_builder .

Afterwards adapt the paths to which your system has mounted the SD card partitions (you can find them using `lsblk` for example):

    SDCARD_BOOT_PATH=/media/user/boot
    SDCARD_ROOT_PATH=/media/user/root

and run

    sudo docker run -it --volume $SDCARD_BOOT_PATH:/media/boot --volume $SDCARD_ROOT_PATH:/media/root rpi_tpm_kernel_builder
    
to build and deploy the kernel to the SD card.