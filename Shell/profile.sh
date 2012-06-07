#!/bin/bash

# 建立Kits的运行环境
# 在~/.bash_profile 添加 source PATH/TO/profile.sh

# 注意 这里不能用相对路径

#K its所在目录
export KITS="$HOME/Developer/Misc/MacOSX-Kits"
export KITSSHELL="$KITS/Shell"

export PATH="$KITSSHELL:$PATH"

# bash提示符
export PS1="\u@\h: \W\$ "

# 历史记录控制
# erasedups = 不重复记录相同的命令
# ignoredups = 不重复记录连续的相同命令
export HISTCONTROL=erasedups

# 运行多个Shell时退出合并历史记录
shopt -s histappend

# 载入私有信息
if [[ -f $KITSSHELL/private.sh ]]; then 
    source $KITSSHELL/private.sh
fi

# 载入别名
if [[ -f $KITSSHELL/alias.sh ]]; then
    source $KITSSHELL/alias.sh
fi