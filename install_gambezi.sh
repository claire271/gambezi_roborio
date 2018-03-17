#!/bin/bash

# Extract tarball
rm -rf gambezi
tar xzvf gambezi.tar.gz
rm gambezi.tar.gz
cd gambezi

# Configure opkg
cp local-feeds.conf /etc/opkg/
rm local-feeds.conf

# Install packages
opkg update
opkg install packagegroup-core-buildessential packagegroup-core-buildessential-dev openssl openssl-dev cmake
opkg clean
rm -rf packages

# Build libuv
unzip libuv.zip
rm libuv.zip
cd libuv-1.13.1
./autogen.sh
./configure
make
make install
cd ..
rm -rf libuv-1.13.1

# Build libwebsockets
unzip libwebsockets.zip
rm libwebsockets.zip
cd libwebsockets-2.2-stable
mkdir build
cd build
cmake .. -DLWS_WITH_LWSWS=1
make
make install
cd ../..
rm -rf libwebsockets-2.2-stable

# Build gambezi
unzip gambezi.zip
rm gambezi.zip
cd gambezi-low_memory
mkdir build
cd build
cmake ..
make
make install
cd ../..
rm -rf gambezi-master

# Configure lwsws
mkdir /etc/lwsws
cp conf /etc/lwsws/
mkdir /etc/lwsws/conf.d
cp gambezi-server /etc/lwsws/conf.d/
rm conf gambezi-server

# Install init script
cp gambezi.sh /etc/init.d/
ln -s /etc/init.d/gambezi.sh /etc/rc5.d/S99gambezi.sh
rm gambezi.sh

# Reboot
init 6
