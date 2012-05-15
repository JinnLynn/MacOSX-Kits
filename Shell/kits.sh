#!/bin/sh

if [ -z $KITS ]; then
    . $(cd $(dirname $0); pwd)/build-env.sh
fi

function usage() {
    more "${KITSSHELL}/misc/kits-usage.txt"
}

case $1 in
    'backup' )     #备份文件到NAS
        $KITSSHELL/backup/backup.sh
        ;;
    'genpac' )     #通过GenPAC生成自动代理配置文件
        $KITS/GenPAC/genpac.py
        ;;
    'mamp' )       #MAMP管理
        $KITSSHELL/mamp.sh $2
        ;;
    'lyric' )      #获取iTunes当前播放曲目的歌词
        osascript $KITS/FetchLyric/FetchLyric.applescript
        ;;
    'usage' )      #使用说明
        usage
        ;;
    'test' )
        echo 'test' >> "/Users/JinnLynn/log.log"
        echo "KITS: ${KITS}" >> "/Users/JinnLynn/log.log"
        ;;
    '' )
        usage
        ;;
    * )
        echo "kits: '$1' is not a kits command. See 'kits usage'."
        ;;
esac