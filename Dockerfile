FROM ubuntu:18.04

ENV HOME /root

RUN apt update && apt install -y \
	build-essential \
	kmod \
	nano \
	wget \
	# - requirements from letstrust.de/archives/P2.html
	bc \
	gcc-arm-linux-gnueabihf \
	gddrescue \
	git \
	libncurses5-dev


# - Retrieve the Raspberry Pi Linux kernel code
WORKDIR $HOME
RUN git clone --depth=1 --progress https://github.com/raspberrypi/tools
## - Set the kernel version to build, otherwise use the current default branch
ARG KERNEL_BRANCH
RUN if [ -z $KERNEL_BRANCH ] ; then git clone --depth=1 --progress https://github.com/raspberrypi/linux ; else git clone --branch=${KERNEL_BRANCH} --depth=1 --progress https://github.com/raspberrypi/linux  ; fi
ENV PATH ${PATH}:~/tools

# - Prepare the build config
WORKDIR $HOME/linux
ENV KERNEL=kernel7
RUN make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
RUN wget https://letstrust.de/uploads/letstrust-tpm-overlay.dts -O arch/arm/boot/dts/overlays/letstrust-tpm-overlay.dts
COPY kernel/.config.patch .
RUN cat .config.patch >> .config

# - Build the kernel
RUN make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs overlays/letstrust-tpm.dtbo -j8

# - Prepare the deploy-to-sd-card script
COPY install_kernel.sh .
RUN chmod u+x install_kernel.sh
COPY kernel/config.txt.patch /tmp

# - Install kernel to sd card
ENTRYPOINT ["./install_kernel.sh"]
