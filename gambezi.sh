#!/bin/bash

### BEGIN INIT INFO
# Provides:          gambezi
# Required-Start:    $local_fs $network
# Required-Stop:     $local_fs $network
# Should-Start:      
# Should-Stop:       
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Starts instance of gambezi
# Description:       Starts instance of gambezi
### END INIT INFO

PID_GAMBEZI_LAUNCHER=/var/run/gambezi_launcher.pid
GAMBEZI_LAUNCHER=/home/admin/gambezi/gambezi_launcher.sh

case "$1" in
	start)
		# Bail if the launcher has already started
		if [ -e $PID_GAMBEZI_LAUNCHER -a -e /proc/`cat $PID_GAMBEZI_LAUNCHER 2> /dev/null` ]; then
			echo "$0 already started"
			exit 1
		fi
		# Start launcher
		touch $PID_GAMBEZI_LAUNCHER
		$GAMBEZI_LAUNCHER &
		echo $! > $PID_GAMBEZI_LAUNCHER
		;;
	stop)
		# Kill launcher
		if [[ -f "$PID_GAMBEZI_LAUNCHER" ]]; then
			kill `cat $PID_GAMBEZI_LAUNCHER`
			rm $PID_GAMBEZI_LAUNCHER
		fi
		;;
esac
