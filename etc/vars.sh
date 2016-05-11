# 终端环境变量
# ==================================

export NASKITS="$HOME/Developer/Misc/Kits/NAS"
export RPIKITS="$HOME/Developer/Misc/Kits/RPi"

export VMUS_KITS="$HOME/Developer/Misc/Kits-UbuntuServer"
export VMUS_HOST="10.211.55.28"
export VMUS_SRV="jinnlynn@$VMUS_HOST"

# Python相关
# 自定义库目录
export PYTHONPATH="$KITS/opt/python/site-packages:$PYTHONPATH"
# pip 要求在虚拟环境中才能运行
export PIP_REQUIRE_VIRTUALENV=true
# pip 自动使用启动中的虚拟环境
export PIP_RESPECT_VIRTUALENV=true
# pylint
export PYLINTRC="$KITS/etc/pylintrc"
# nosetests
export NOSE_WITH_YANC=true
export NOSE_YANC_COLOR='on'

# autossh
export AUTOSSH_LOGLEVEL="7"
export AUTOSSH_LOGFILE="$KITS_LOG/autossh.log"
[[ ! -f $AUTOSSH_LOGFILE ]] && touch $AUTOSSH_LOGFILE
# 该参数值越小，能较少长时间无法连接SSH后再次连接的间隔时间
export AUTOSSH_POLL="30"
export AUTOSSH_PIDFILE="$KITS_RUN/autossh.pid"

export DROPBOX_HOME=$(jsoner -k personal.path -f $HOME/.dropbox/info.json)

export PROXY_FUNC="kits_shadowsocks kits_polipo"
export ALIVE_CHECK_FUNC="$PROXY_FUNC kits_vpn kits_memp"