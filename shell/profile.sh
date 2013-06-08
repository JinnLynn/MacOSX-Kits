#!/bin/bash

#! 这里不能用相对路径
#! KITS 将在~/.kits_path中 如果不存在该文件运行setup即可生成

export NASKITS="$HOME/Developer/Misc/NAS-Kits"
export RPIKITS="$HOME/Developer/Misc/RPi-Kits"

export PATH="$KITS/bin:$PATH"

# bash提示符
export PS1="\u@\h: \W\$ "

# 历史记录控制
# erasedups = 不重复记录相同的命令
# ignoredups = 不重复记录连续的相同命令
export HISTCONTROL=erasedups

# 运行多个Shell时退出合并历史记录
shopt -s histappend

# 总是展开别名
shopt -s expand_aliases

# 设置颜色显示
export CLICOLOR=1

# pip 要求在虚拟环境中才能运行
export PIP_REQUIRE_VIRTUALENV=true
# pip 自动使用启动中的虚拟环境
export PIP_RESPECT_VIRTUALENV=true

# virtualenvwrapper 环境
if [[ -f /usr/local/bin/virtualenvwrapper.sh ]]; then
    export WORKON_HOME=~/.virtualenvs
    [[ ! -d $WORKON_HOME ]] && mkdir $WORKON_HOME
    . /usr/local/bin/virtualenvwrapper.sh
fi

# 载入私有信息
[[ -f $KITS/shell/privacy.sh ]] && . $KITS/shell/privacy.sh

# 载入通用命令
[[ -f $KITS/shell/common.sh ]] && . $KITS/shell/common.sh

# 载入kits
[[ -f $KITS/shell/kits.sh ]] && . $KITS/shell/kits.sh

# 载入别名
[[ -f $KITS/shell/alias.sh ]] && . $KITS/shell/alias.sh