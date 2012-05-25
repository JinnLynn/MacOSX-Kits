#!/bin/bash

# 建立Kits的运行环境
# 在~/.bash_profile 添加 source PATH/TO/build-env.sh

# 注意 这里不能用相对路径

#Kits所在目录
export KITS="${HOME}/Developer/Misc/MacOSX-Kits"

export KITSSHELL="${KITS}/Shell"
export PATH="${KITSSHELL}:${PATH}"

#建立别名
alias kits="kits.sh"
alias env=". ~/.bashrc; echo 'rebuild env ok.'"
alias ls="ls -h"
alias ll="ls -l"

alias subl="/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl"