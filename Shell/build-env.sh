#!/bin/bash

# 建立Kits的运行环境
# 在~/.bash_profile 添加·source PATH/TO/build-env.sh

export KITS=~/Developer/Misc/MacOSX-Kits
export PATH=$KITS/Shell:$PATH

alias mstart="mamp.sh start"
alias mstop="mamp.sh stop"
alias mrestart="mamp.sh restart"