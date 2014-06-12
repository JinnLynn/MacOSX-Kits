#!/bin/bash

#! 这里不能用相对路径
#! KITS 将在~/.kits_path中 如果不存在该文件运行setup即可生成

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

# autojump
[[ -s $(brew --prefix)/etc/autojump.sh ]] && . $(brew --prefix)/etc/autojump.sh

# virtualenvwrapper
[[ -n "$(which virtualenvwrapper_lazy.sh)" ]] && . "$(which virtualenvwrapper_lazy.sh)"

# 载入环境变量
[[ -f $KITS/shell/variables.sh ]] && . $KITS/shell/variables.sh

# 载入私有环境变量
[[ -f $KITS/private/shell-variables.sh ]] && . $KITS/private/shell-variables.sh 

# 加载commands下所有sh文件
for _f in $(ls $KITS/shell/commands/*.sh 2>/dev/null); do . $_f; done 

# 载入别名
[[ -f $KITS/shell/alias.sh ]] && . $KITS/shell/alias.sh

# 载入私有命令
for _f in $(ls $KITS/private/shell-commands/*.sh 2>/dev/null); do . $_f; done 

# 载入私有别名
[[ -f $KITS/private/shell-alias.sh ]] && . $KITS/private/shell-alias.sh 

unset _f