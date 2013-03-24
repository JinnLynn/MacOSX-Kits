#!/bin/bash

# 注意 这里不能用相对路径

# Kits相关 KITS在../dotfiles/bashrc.sh中配置

export NASKITS="$HOME/Developer/Misc/NAS-Kits"
export RPIKITS="$HOME/Developer/Misc/RPi-Kits"

export PATH="$KITS/shell:$KITS/bin:$PATH:$KITS/bin/terminal-notifier.app/Contents/MacOS"

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

# pip 要求在虚拟环境中才能运行
export PIP_REQUIRE_VIRTUALENV=true
# pip 自动使用启动中的虚拟环境
export PIP_RESPECT_VIRTUALENV=true

# virtualenvwrapper 环境
export WORKON_HOME=~/.virtualenvs
[[ ! -d $WORKON_HOME ]] && mkdir $WORKON_HOME
[[ -f /usr/local/bin/virtualenvwrapper.sh ]] && . /usr/local/bin/virtualenvwrapper.sh

# 载入私有信息
[[ -f $KITS/shell/privacy.sh ]] && . $KITS/shell/privacy.sh

# 载入别名
[[ -f $KITS/shell/alias.sh ]] && . $KITS/shell/alias.sh