#!/bin/bash

function start() {
    /Applications/MAMP/bin/startMysql.sh
    /Applications/MAMP/bin/startApache.sh
}

function stop() {
    /Applications/MAMP/bin/stopMysql.sh
    /Applications/MAMP/bin/stopApache.sh
}

case $1 in
    'start' )
        start
        ;;
    'stop' )
        stop
        ;;
    'restart' )
        stop
        start
        ;;
    * )
        echo "mamp: '$1' is not a mamp command."
esac