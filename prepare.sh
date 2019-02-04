#!/bin/bash

# Get all sources and packages needed
mkdir gambezi
cd gambezi

# Roborio packages
mkdir packages
cd packages

# Download package lists
feeds_url=http://download.ni.com/ni-linux-rt/feeds/2018/arm
function get_package_list {
	mkdir $1
	cd $1
	wget -nc $feeds_url/$1/Packages.gz
	if [ ! -f Packages ]; then
		gunzip -k Packages.gz
	fi
	cd ..
}
get_package_list all
get_package_list cortexa9-vfpv3
get_package_list xilinx-zynq

# Queue up packages and dependencies
packages=()
package_names=()
package_source=()
function search_repo {
	# Test to ensure the package is found in this repository
	local package_info=$(sed -n "/Package: $1\$/,/^$/p" $2/Packages)
	if [ -n "$package_info" ]; then
		# Test to ensure the package is not already queued up
		local contains=false
		for package in ${packages[@]}; do
			if [ $1 == $package ]; then
				local contains=true
			fi
		done
		if [ $contains == false ]; then
			# Add this package to the download queue
			packages+=($1)
			package_names+=("$feeds_url/$2/$(echo "$package_info" | grep "Filename:" | awk '{ print $2 }')")
			package_source+=($2)
			# Process dependencies
			local dependencies=$(echo "$package_info" | grep "Depends:" | cut -d " " -f 2- | sed "s/([^)]*)//g" | sed "s/,//g")
			for dependency in $dependencies; do
				get_package $dependency
			done
			local dependencies=$(echo "$package_info" | grep "Recommends:" | cut -d " " -f 2- | sed "s/([^)]*)//g" | sed "s/,//g")
			for dependency in $dependencies; do
				get_package $dependency
			done
		fi
	fi
}
function get_package {
	search_repo $1 all
	search_repo $1 cortexa9-vfpv3
	search_repo $1 xilinx-zynq
}
get_package "packagegroup-core-buildessential"
get_package "packagegroup-core-buildessential-dev"
get_package "openssl"
get_package "openssl-dev"
get_package "cmake"

# Download packages
for i in ${!package_names[@]}; do
	cd ${package_source[$i]}
	wget -nc ${package_names[$i]}
	cd ..
done
cd ..

# Donwload libwebsockets
wget -nc https://github.com/libuv/libuv/archive/v1.13.1.zip
mv v1.13.1.zip libuv.zip

# Donwload libwebsockets
wget -nc https://github.com/warmcat/libwebsockets/archive/v2.2-stable.zip
mv v2.2-stable.zip libwebsockets.zip

# Download Gambezi server
wget -nc https://github.com/tigerh/gambezi/archive/low_memory.zip
mv low_memory.zip gambezi.zip
cd ..

# Copy opkg config files
cp local-feeds.conf gambezi/

# Copy lwsws config files
cp conf gambezi/
cp gambezi-server gambezi/

# Copy launchder
cp gambezi_launcher.sh gambezi/

# Copy init scripts
cp gambezi.sh gambezi/

# Tar and send over the network
tar czvf gambezi.tar.gz gambezi
