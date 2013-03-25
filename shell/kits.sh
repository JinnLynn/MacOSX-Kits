#!/bin/bash

# 检查环境变量
[[ -z $KITS ]] && [[ -f ~/.bashrc ]] && . ~/.bashrc

# 备份文件到NAS
function kits_backup() {
    if [ ! -L /tmp/kits-backup-Application-Support ]; then
        ln -s "/Users/JinnLynn/Library/Application Support/" "/tmp/kits-backup-Application-Support"
    fi
    $KITS/extra/backup/backup.sh
}

# 使用GenPAC生成自动代理配置文件
function kits_genpac() {
    python $KITS/extra/genpac/genpac.py
}

# 使用`预览`打开man内容
function kits_manp() {
    man -t $1 | open -f -a /Applications/Preview.app
}