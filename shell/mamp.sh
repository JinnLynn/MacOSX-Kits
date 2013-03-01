#!/bin/bash

##
# MAMP相关控制
##

pushd /Applications/MAMP/bin/ > /dev/null
case "$1" in
    "start" )
        ./start.sh
        ;;
    "stop" )
        ./stop.sh
        ;;
    "restart" )
        ./stop.sh
        sleep 1
        ./start.sh
        ;;
    "isrunning" )
        [[ $(ps -ec | grep -c "httpd") -gt 0 ]] && echo "Apache is running." || echo "Apache is not running."
        [[ $(ps -ec | grep -c "mysqld") -gt 0 ]] && echo "MySQL is running." || echo "MySQL is not running."
        ;;
    * )
        echo "ERROR. Usage: mamp.sh <start|stop|restart|isrunning>"
        ;;
esac
popd > /dev/null
