FROM ubuntu:18.04

ENV HOME /root

RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf && apt update && apt install -y \
	build-essential \
	kmod \
	nano \
	wget \
	# - requirements from letstrust.de/archives/P2.html
	bc \
	gcc-arm-linux-gnueabihf \
	gddrescue \
	git \
	libncurses5-dev \
	# - required by kernel v4.15
	libssl-dev \
	# - required by kernel v4.16
	bison flex \
	gcc-aarch64-linux-gnu



# - Retrieve the Raspberry Pi Linux kernel code
WORKDIR $HOME
RUN git clone --depth=1 --progress https://github.com/raspberrypi/tools
## - Set the kernel version to build, otherwise use the current default branch
ARG KERNEL_BRANCH
RUN if [ -z $KERNEL_BRANCH ] ; then git clone --depth=1 --progress https://github.com/raspberrypi/linux ; else git clone --branch=${KERNEL_BRANCH} --depth=1 --progress https://github.com/raspberrypi/linux  ; fi
ENV PATH ${PATH}:~/tools

# - Prepare the build config
WORKDIR $HOME/linux
## - Define the kernel to build
##   Options:
##     - kernel7: For Pi 2, Pi 3, or Compute Module 3 (default)
##     - kernel: For Pi 1, Pi Zero, Pi Zero W, or Compute Module
ARG KERNEL=kernel7
ENV KERNEL=${KERNEL}
RUN make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcmrpi3_defconfig
RUN wget https://letstrust.de/uploads/letstrust-tpm-overlay.dts -O arch/arm64/boot/dts/overlays/letstrust-tpm-overlay.dts
COPY kernel/.config.patch .
RUN cat .config.patch >> .config

# - Build the kernel
RUN make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image modules dtbs -j8

# - Prepare the deploy-to-sd-card script
COPY install_kernel.sh .
RUN chmod u+x install_kernel.sh
COPY kernel/config.txt.patch /tmp

# - Install kernel to sd card
#ENTRYPOINT ["./install_kernel.sh", ${KERNEL}]
