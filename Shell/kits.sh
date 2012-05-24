#!/bin/bash

#检查环境变量
if [ -z $KITS ]; then
    . $(cd $(dirname $0); pwd)/build-env.sh
fi

#Applescrit接口文件
OSASPORT=$KITSSHELL/osasport.applescript

#使用说明
function usage() {
    more "$KITSSHELL/misc/kits-usage.txt"
}

#私有操作
function private() {
    if [ -f $KITSSHELL/private.sh ]; then 
        . $KITSSHELL/private.sh $1 $2
    else
        echo 'kits: private is not a kits command.'
    fi
}

case $1 in
    'backup' )     #备份文件到NAS
        . $KITSSHELL/backup/backup.sh
        ;;
    'genpac' )     #通过GenPAC生成自动代理配置文件
        $KITS/GenPAC/genpac.py
        ;;
    'mamp' )       #MAMP管理
        $KITSSHELL/mamp.sh $2
        ;;
    'itunes' )     #部分itunes操作
        osascript $OSASPORT itunes $2 $3
        ;;
    'sshkey' )     #SSH秘钥处理
        private sshkey $2
        ;;
    'private' )    #私有的一些操作
        private $2 $3
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