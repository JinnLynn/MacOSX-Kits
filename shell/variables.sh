
# Python相关
# 自定义库目录
export PYTHONPATH=$KITS/python/libs:$PYTHONPATH
# pip 要求在虚拟环境中才能运行
export PIP_REQUIRE_VIRTUALENV=true
# pip 自动使用启动中的虚拟环境
export PIP_RESPECT_VIRTUALENV=true

# 默认的日志输出目录
export KITS_LOGPATH=~/Library/Logs/net.jeeker.kits
[[ ! -d $KITS_LOGPATH ]] && mkdir -p $KITS_LOGPATH && chmod -R 777 $KITS_LOGPATH

# 默认临时目录
export KITS_TMP="$KITS/tmp" 
[[ ! -d $KITS_TMP ]] && mkdir -p $KITS_TMP && chmod -R 777 $KITS_TMP

# autossh
export AUTOSSH_LOGLEVEL="7"
export AUTOSSH_LOGFILE="$KITS_LOGPATH/autossh.log"
[[ ! -f $AUTOSSH_LOGFILE ]] && touch $AUTOSSH_LOGFILE
# 该参数值越小，能较少长时间无法连接SSH后再次连接的间隔时间
export AUTOSSH_POLL="30"