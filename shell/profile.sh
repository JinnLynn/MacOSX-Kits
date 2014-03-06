#!/bin/bash

#! 这里不能用相对路径
#! KITS 将在~/.kits_path中 如果不存在该文件运行setup即可生成

export NASKITS="$HOME/Developer/Misc/NAS-Kits"
export RPIKITS="$HOME/Developer/Misc/RPi-Kits"

# export PATH="$KITS/bin:$PATH"
export PATH="$KITS/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

# bash提示符
# export PS1="\u@\h: \W\$ "
export PS1="\u@\h$([[ ! -z "$STY" ]] && echo "[$STY]"): \W\$ "

# 历史记录控制
# erasedups = 不重复记录相同的命令
# ignoredups = 不重复记录连续的相同命令
export HISTCONTROL=erasedups

# 运行多个Shell时退出合并历史记录
shopt -s histappend

# 忽略邮件检查
unset MAILCHECK

# 总是展开别名
shopt -s expand_aliases

# 设置颜色显示
export CLICOLOR=1

# pip 要求在虚拟环境中才能运行
export PIP_REQUIRE_VIRTUALENV=true
# pip 自动使用启动中的虚拟环境
export PIP_RESPECT_VIRTUALENV=true

# autojump
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

# virtualenvwrapper
[[ ! -z "$(which virtualenvwrapper_lazy.sh)" ]] && 
    . "$(which virtualenvwrapper_lazy.sh)"

# autossh
# export AUTOSSH_DEBUG="1"
export AUTOSSH_LOGLEVEL="7"
export AUTOSSH_LOGFILE="/Users/JinnLynn/Library/Logs/autossh.log"
[[ ! -f $AUTOSSH_LOGFILE ]] && touch $AUTOSSH_LOGFILE
# 该参数值越小，能较少长时间无法连接SSH后再次连接的间隔时间
export AUTOSSH_POLL="30"

# 载入私有信息
[[ -f $KITS/shell/privacy.sh ]] && . $KITS/shell/privacy.sh

# 加载commands下所有sh文件
for _f in `ls $KITS/shell/commands/*.sh`; do . $_f; done 

# 载入别名
[[ -f $KITS/shell/alias.sh ]] && . $KITS/shell/alias.sh