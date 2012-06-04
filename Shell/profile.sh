#!/bin/bash

# 建立Kits的运行环境
# 在~/.bash_profile 添加 source PATH/TO/build-env.sh

# 注意 这里不能用相对路径

#Kits所在目录
export KITS="${HOME}/Developer/Misc/MacOSX-Kits"

export KITSSHELL="${KITS}/Shell"
export PATH="${KITSSHELL}:${PATH}"

#载入私有信息
if [ -f $KITSSHELL/private.sh ]; then 
    source $KITSSHELL/private.sh
fi

#载入别名
if [ -f $KITSSHELL/alias.sh ]; then
    source $KITSSHELL/alias.sh
fi