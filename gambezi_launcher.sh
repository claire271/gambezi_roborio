#!/bin/bash

# Utility functions
logfile="/home/admin/gambezi/gambezi.log"
bin_lwsws="/usr/local/bin/lwsws"
function start_lwsws {
        if [ -f $logfile ]; then
                rm $logfile
        fi
        $bin_lwsws > $logfile 2>&1 &
}
function kill_lwsws {
        pids=$(ps -e | grep "lwsws$" | awk '{print $1}')
        for pid in $pids; do
                kill $pid
        done
}

# Cleanup here
function cleanup {
        kill_lwsws
        exit
}
trap "cleanup" SIGTERM

# lwsws and other programs
start_lwsws

# Monitoring
while true; do
        # Server didn't launch properly
        if grep -q "init server failed" $logfile; then
                kill_lwsws
                start_lwsws
        fi
        # Some error occurred within the gambezi plugin
        if grep -q "SHUTDOWN REQUESTED" $logfile; then
                kill_lwsws
                start_lwsws
        fi

        # Don't waste too many cpu cycles
        sleep 5
done
