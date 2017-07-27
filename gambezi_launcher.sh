#!/bin/bash

function cleanup {
        exit
}
trap "cleanup" SIGTERM

cd /home/admin/gambezi/
touch test.txt

while true; do
	echo "." >> test.txt
	sleep 1
done
