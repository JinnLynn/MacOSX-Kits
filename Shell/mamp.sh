#!/bin/bash

##
# MAMP相关控制
##

res=""
pushd /Applications/MAMP/bin/ > /dev/null
if [[ "$1" = 'start' ]]; then
    ./start.sh
    res="MAMP started."
elif [[ "$1" = 'stop' ]]; then
    ./stop.sh
    res="MAMP stopped."
elif [[ "$1" = 'restart' ]]; then
    ./stop.sh
    sleep 1
    ./start.sh
    res="MAMP restarted."
elif [[ "$1" = 'isrunning' ]]; then
    hres="Apache is not running."
    mres="Mysql is not running."
    if [[ $(ps -ec | grep -c "httpd") -gt 0 ]]; then 
        hres="Apache is running."
    fi
    if [[ $(ps -ec | grep -c "mysqld") -gt 0 ]]; then
        mres="Mysql is running."
    fi
    res="$hres\n$mres"
else
    res="ERROR. Usage: mamp.sh <start|stop|restart|isrunning>"
fi 
popd > /dev/null
echo -e "$res"