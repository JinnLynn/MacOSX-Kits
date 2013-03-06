#!/bin/bash

# 注意 这里不能用相对路径

# Kits相关 KITS在../dotfiles/bashrc.sh中配置

export NASKITS="$HOME/Developer/Misc/NAS-Kits"

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

# 载入私有信息
[[ -f $KITS/shell/privacy.sh ]] && . $KITS/shell/privacy.sh

# 载入别名
[[ -f $KITS/shell/alias.sh ]] && . $KITS/shell/alias.sh