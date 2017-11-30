# ESP Open SDK Docker Image

This image contains the necessary toolchain and libraries to build
code for ESP8266 devices using the ESP Open SDK toolkit.

## Usage

To build sources in your current directory using `make`:

    docker run --rm -v $HOME:$HOME -u $UID -w $PWD larsks/esp-open-sdk make

Flashing the firmware is a little more complicated because it requires
access to the serial device, which may require explicit group
membership.  On my system, serial devices are available to members of
the `dialout` group, so the command line looks like:

    docker run \
      --device /dev/ttyUSB0 \
      -v /etc/passwd:/etc/passwd \
      -v /etc/group:/etc/group \
      -v $HOME:$HOME \
      -u $UID \
      --group-add dialout \
      -w $PWD \
      larsks/esp-open-sdk make flash ESPPORT=/dev/ttyUSB0

## Wrapper script

You can install a convenient wrapper script with the following
command:

    docker run --rm -u $UID -v $HOME/bin:/target larsks/esp-open-sdk install-wrapper

The above command would install a script named `esp-sdk` in
`$HOME/bin` that simplifies calling docker.  Once the script is
installed, you can run:

    esp-sdk make

Or:

    esp-sdk xtensa-lx106-elf-gcc-nm

Or:

    esp-sdk esptool.py

Etc.
