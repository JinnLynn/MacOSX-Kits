#!/bin/bash

function start() {
    /Applications/MAMP/bin/startMysql.sh
    /Applications/MAMP/bin/startApache.sh
}

function stop() {
    /Applications/MAMP/bin/stopMysql.sh
    /Applications/MAMP/bin/stopApache.sh
}

#echo $PATH

case $1 in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
esac

#echo $KITS