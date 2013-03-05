#!/bin/bash

# 注意 这里不能用相对路径

# Kits相关 KITS在../dotfiles/bashrc.sh中配置

export KITSSHELL="$KITS/shell"
export KITSBIN="$KITS/bin"

export NASKITS="$HOME/Developer/Misc/NAS-Kits"

export PATH="$KITSSHELL:$KITSBIN:$PATH:$KITSBIN/terminal-notifier.app/Contents/MacOS"

# bash提示符
export PS1="\u@\h: \W\$ "

# 历史记录控制
# erasedups = 不重复记录相同的命令
# ignoredups = 不重复记录连续的相同命令
export HISTCONTROL=erasedups

# 运行多个Shell时退出合并历史记录
shopt -s histappend

# 设置颜色显示
export CLICOLOR=1

# 载入私有信息
if [[ -f $KITSSHELL/privacy.sh ]]; then 
    source $KITSSHELL/privacy.sh
fi

# 载入别名
if [[ -f $KITSSHELL/alias.sh ]]; then
    source $KITSSHELL/alias.sh
fi