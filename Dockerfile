######################################################################
##
## STAGE 1: Build xtensa toolchain
##

FROM fedora:33

ARG ESP_SDK_REF=master

RUN yum -y upgrade
RUN yum -y install make autoconf automake libtool gcc gcc-c++ \
	flex bison ncurses-devel expat-devel python-devel \
	git unzip wget bzip2 gperf which texinfo help2man patch \
	file xz

RUN useradd tools
RUN mkdir /tools && chown -R tools:tools /tools
USER tools
RUN git clone --recursive https://github.com/pfalcon/esp-open-sdk.git /tools
COPY *.patch /tools
RUN git config --global user.name docker && \
	git config --global user.email docker
RUN cd /tools && \
	git checkout ${ESP_SDK_REF} && \
	git am 0001-Fix-build-errors-with-bash-4.patch && \
	make

######################################################################
##
## STAGE 2: This is the final image.
##

FROM fedora:33

RUN yum -y install make autoconf automake libtool python2 pyserial \
	which git
COPY --from=0 /tools/xtensa-lx106-elf /tools/xtensa-lx106-elf
ENV PATH=/tools/xtensa-lx106-elf/bin:/bin:/usr/bin
RUN mkdir /usr/lib/esp-open-sdk
COPY install-wrapper /usr/bin/install-wrapper
COPY esp-open-sdk /usr/lib/esp-open-sdk/esp-open-sdk
