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
    'backup' )     #备份文件到NAS
        backup.shl
        ;;
    'genpac' )     #通过GenPAC生成自动代理配置文件
        $KITS/GenPAC/genpac.py
        ;;
    'mamp' )       #MAMP管理
        mamp $2
        ;;
    'lyric' )      #获取iTunes当前播放曲目的歌词
        osascript $KITS/FetchLyric/FetchLyric.applescript
        ;;
    'usage' )      #使用说明
        usage
        ;;
    '' )
        usage
        ;;
    * )
        echo "kits: '$1' is not a kits command. See 'kits usage'."
        ;;
esac