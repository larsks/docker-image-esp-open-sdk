######################################################################
##
## STAGE 1: Build xtensa toolchain
##

FROM fedora

RUN yum -y upgrade
RUN yum -y install make autoconf automake libtool gcc gcc-c++ \
	flex bison ncurses-devel expat-devel python-devel \
	git unzip wget bzip2 gperf which texinfo help2man patch \
	file xz

RUN useradd tools
RUN mkdir /tools && chown -R tools:tools /tools
USER tools
RUN git clone --recursive https://github.com/pfalcon/esp-open-sdk.git /tools
RUN cd /tools && make

######################################################################
##
## STAGE 2: This is the final image.
##

FROM fedora

RUN yum -y install make autoconf automake libtool python2 pyserial \
	which git
COPY --from=0 /tools/xtensa-lx106-elf /tools/xtensa-lx106-elf
ENV PATH=/tools/xtensa-lx106-elf/bin:/bin:/usr/bin
RUN mkdir /usr/lib/esp-open-sdk
COPY install-wrapper /usr/bin/install-wrapper
COPY esp-open-sdk /usr/lib/esp-open-sdk/esp-open-sdk
