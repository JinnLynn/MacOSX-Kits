#!/bin/bash

# 是否显示隐藏的文件
function hidden_files() {
    cmd='NO'
    if [ "$1" = 'show' ]; then cmd='YES'; fi
    defaults write com.apple.Finder AppleShowAllFiles $cmd
    osascript -e 'tell application "Finder" to quit'
    sleep 1
    osascript -e 'tell application "Finder" to activate'
}

# 与Finder相关操作
function finder() {
    if [ "$1" = 'open' ]; then
        open_folder_in_finder $2
    fi
}

# 在Finder中打开文件夹
function open_folder_in_finder() {
    # 如果: 无参数取当前工作目录；是文件取其所在文件夹路径
    folder=$1
    if [ -z "$folder" ]; then
        folder=$(pwd)
    elif [ -f "$folder" ]; then
        folder=$(dirname $folder)
    fi
    # 避免当路径是'.'时Finder无法找到
    if [ "$folder" = '.' ]; then folder=$(pwd); fi
    cmdvar1='tell application "Finder" to open folder { "'
    cmdvar2='" }'
    CMD=$cmdvar1$folder$cmdvar2
    osascript -e "$CMD"
    # 执行成功激活Finder
    if [ "$?" = '0' ]; then
        osascript -e 'tell application "Finder" to activate'
    fi
}

case $1 in
    'hiddenfiles' )     #隐藏文件的显示与隐藏
        hidden_files $2
        ;;
    'finder' )
        finder $2 $3
        ;;
    * )
        echo "kits: '$1' is not a kits command. See 'kits usage'."
        ;;
esac

#open_folder_in_Finder $1