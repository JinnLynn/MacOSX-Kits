#!/bin/bash

#检查环境变量
if [ -z $KITS ]; then
    . $(cd $(dirname $0); pwd)/profile.sh
fi

#私有操作
function privacy() {
    if [ -f $KITS/shell/privacy.sh ]; then 
        . $KITS/shell/privacy.sh $1 $2
    else
        echo 'kits: privacy is not a kits command.'
    fi
}

# 使用`预览`打开man内容
function manp() {
  man -t $1 | open -f -a /Applications/Preview.app
}

case $1 in
    'backup' )     #备份文件到NAS
        if [ ! -L /tmp/kits-backup-Application-Support ]; then
            ln -s "/Users/JinnLynn/Library/Application Support/" "/tmp/kits-backup-Application-Support"
        fi
        $KITS/extra/backup/backup.sh
        ;;
    'genpac' )     #通过GenPAC生成自动代理配置文件
        $KITS/extra/genpac/genpac.py
        ;;
    'manp' )
        manp $2
        ;;
    * )
        echo "ERROR. Usage: kits.sh <backup|genpac|itunes|manp>"
        ;;
esac