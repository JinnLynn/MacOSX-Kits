#!/bin/bash

##
# squid相关控制
##

pid=$(ps ax | grep "squid" | awk '{print $1, $5}' | grep "(squid)" | awk '{print $1}')
# 基于SquidMan生成的配置文件
conf=~/Library/Preferences/squid.conf

case "$1" in
    "start" )
        /usr/local/squid/sbin/squid -f $conf
        ;;
    "stop" )
        if [[ -n "$pid" ]]; then kill -9 $pid; fi
        ;;
    "restart" )
        squid.sh stop
        sleep 1
        squid.sh start
        ;;
    "isrunning" )
        [[ -n "$pid" ]] && echo "squid is running." || echo "squid is not running"
        ;;
    * )
        echo "ERROR. Usage: squid.sh <start|stop|restart|isrunning>"
esac