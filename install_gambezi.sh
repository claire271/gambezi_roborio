#!/bin/bash

# Extract tarball
rm -rf gambezi
tar xzvf gambezi.tar.gz
cd gambezi

# Configure opkg
cp local-feeds.conf /etc/opkg/

# Install packages
opkg update
opkg install packagegroup-core-buildessential packagegroup-core-buildessential-dev openssl openssl-dev cmake

# Build libuv
unzip libuv.zip
cd libuv-1.13.1
./autogen.sh
./configure
make
make install
cd ..

# Build libwebsockets
unzip libwebsockets.zip
cd libwebsockets-2.2-stable
mkdir build
cd build
cmake .. -DLWS_WITH_LWSWS=1
make
make install
cd ../..

# Build gambezi
unzip gambezi.zip
cd gambezi-master
mkdir build
cd build
cmake ..
make
make install
cd ../..

# Configure lwsws
mkdir /etc/lwsws
cp conf /etc/lwsws/
mkdir /etc/lwsws/conf.d
cp gambezi-server /etc/lwsws/conf.d/

# Install init script
cp ./lwsws /etc/init.d/
ln -s /etc/init.d/lwsws /etc/rc5.d/S99lwsws

# Cleanup
opkg clean
rm -rf conf gambezi-master gambezi-server gambezi.zip libuv-1.13.1 libuv.zip libwebsockets-2.2-stable libwebsockets.zip local-feeds.conf packages
init 6
