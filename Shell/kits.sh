#!/bin/sh

function mamp() {
    case $1 in
        'start' )
            mamp.sh start
            ;;
        'stop' )
            mamp.sh stop
            ;;
        'restart' )
            mamp.sh restart
            ;;
    esac
}

function usage() {
    more "${KITSSHELL}/misc/kits-usage.txt"
}

case $1 in
    'usage' )
        usage
        ;;
    'backup' )
        backup.shl
        ;;
    'mamp' )
        mamp $2
        ;;
    * )
        echo "kits: '$1' is not a kits command. See 'kits usage'."
        ;;
esac