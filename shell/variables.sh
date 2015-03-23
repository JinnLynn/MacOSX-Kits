# 默认的日志输出目录
export KITS_LOG="$HOME/Library/Logs/net.jeeker.kits"
[[ ! -d $KITS_LOG ]] && mkdir -p $KITS_LOG && chmod -R 777 $KITS_LOG

# 默认临时目录
export KITS_TMP="$KITS/tmp" 
[[ ! -d $KITS_TMP ]] && mkdir -p $KITS_TMP && chmod -R 777 $KITS_TMP

export NASKITS="$HOME/Developer/Misc/Kits/NAS"
export RPIKITS="$HOME/Developer/Misc/Kits/RPi"

export VMUS_KITS="$HOME/Developer/Misc/Kits-UbuntuServer"
export VMUS_HOST="10.211.55.28"
export VMUS_SRV="jinnlynn@$VMUS_HOST"

# Python相关
# 自定义库目录
export PYTHONPATH="$KITS/extra/python-packages:$PYTHONPATH"
# pip 要求在虚拟环境中才能运行
export PIP_REQUIRE_VIRTUALENV=true
# pip 自动使用启动中的虚拟环境
export PIP_RESPECT_VIRTUALENV=true
# pylint
export PYLINTRC="$HOME/.pylintrc"
# nosetests
export NOSE_WITH_YANC=true
export NOSE_YANC_COLOR='on'

# autossh
export AUTOSSH_LOGLEVEL="7"
export AUTOSSH_LOGFILE="$KITS_LOG/autossh.log"
[[ ! -f $AUTOSSH_LOGFILE ]] && touch $AUTOSSH_LOGFILE
# 该参数值越小，能较少长时间无法连接SSH后再次连接的间隔时间
export AUTOSSH_POLL="30"

# Dropbox目录
export DROPBOX_HOME="/Volumes/ExtraHD/Clouds/Dropbox"

# 开发相关
export ADT_ROOT="$HOME/Developer/Android/ADT"
export ANT_ROOT="/usr/local/bin"
export NDK_ROOT="$ADT_ROOT/android-ndk-r9d"
export ANDROID_SDK_ROOT="$ADT_ROOT/sdk"
# Cocos2d-X目录
export COCOS2DX_HOME="$HOME/Developer/SDKs/cocos2d-x-3.0"
alias cocos="$COCOS2DX_HOME/tools/cocos2d-console/bin/cocos"
