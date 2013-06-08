#!/usr/bin/env bash

# 检查环境变量
[[ -z $KITS ]] && [[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -z $KITS ]] && echo 'load kits fail.' && return 1

# 加载inc下所有sh文件
for _f in `ls $KITS/shell/inc/*.sh`; do . $_f; done 

# 备份文件到NAS
function kits_backup() {
    $KITS/extra/backup/backup.py $1
}

# 使用GenPAC生成自动代理配置文件
function kits_pac_gen() {
    python $KITS/extra/genpac/genpac.py
}

# 生成pac并发布
function kits_pac_pub() {
    gist_repo=~/Developer/Misc/Gist/5001700
    # push到gist要求的改变数量
    push_changed=10
    # 生成
    kits_pac_gen
    pushd $gist_repo > /dev/null
    # 当改变达到一定数量时自动push到gist
    if [[ $(git diff --numstat pac.js | awk '{print $1}') -gt $push_changed ]]; then 
        git commit -a -m 'updated' 
        git push 
        echo 'gist updated.'
    fi
    popd > /dev/null
}

# 使用Preview | more | dash打开man内容
function kits_man() {
    error="ERROR. Usage: kits_man [-p|-m|-d] COMMAND_NAME"
    [[ -z "$2" ]] && echo "$error" && return 1
    case $1 in
        "-p" )
            man -t $2 | open -f -a /Applications/Preview.app
        ;;
        "-m" )
            man $2 | more
        ;;
        "-d" )
            open "dash://man:$2"
        ;;
        * )
            echo $error
        ;;
    esac
}

# 别名查找
function kits_alias_find() {
   alias | awk -F '=' {'print $1'} | awk {'print $2'} | grep "$1"
}