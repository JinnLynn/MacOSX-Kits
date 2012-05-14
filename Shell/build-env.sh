#!/bin/bash

# 建立Kits的运行环境
# 在~/.bash_profile 添加·source PATH/TO/build-env.sh

# 注意 这里不能用相对路径

export KITS=~/Developer/Misc/MacOSX-Kits
export PATH=$KITS/Shell:$PATH


#建立链接 链接文件后缀加l，便于GIT忽略
ln -sf $KITS/Backup.with.SSH.and.Rsync/backup.sh $KITS/Shell/backup.shl

#建立别名
alias mstart="mamp.sh start"
alias mstop="mamp.sh stop"
alias mrestart="mamp.sh restart"