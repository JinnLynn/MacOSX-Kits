
##
# SSH相关
##

# 重置SSH相关
function kits_ssh_reset() {
    echo "列出当前系统秘钥..."
    ssh-add -l
    echo "删除所有秘钥..."
    ssh-add -D
    echo "删除known_hosts..."
    rm -rf ~/.ssh/known_hosts
    echo "清除可能存在的无用SSH_AUTH_SOCK..."
    echo "当前SSH_AUTH_SOCK值: $SSH_AUTH_SOCK"
    for i in $(ls /tmp/launch-*/Listeners); do
        if [[ "$i" != "$SSH_AUTH_SOCK" ]]; then
            rm -rf $(dirname $i)
            echo "${i} was removed."
        fi
    done
    echo '重新安装秘钥...'
    ssh-add $JKEY
    ssh-add ~/.ssh/jSSHChinaKey
}

# ssh代理
function kits_ssh_proxy() {
    mp="55000"
    case "$1" in
        "start" | "restart" )
            kits_ssh_proxy stop
            autossh -M $mp -f -N -D $JPROXY_SOCKS_PORT -i "$JPROXY_SERVER_KEY" $JPROXY_SERVER
            ;;
        "stop" )
            pid=`ps aux | grep ssh | grep $mp:127.0.0.1:$mp | awk '{print $2}'`
            [[ ! -z "$pid" ]] && kill $pid
            ;;
        "isrunning" )
            # 查找进程
            ret=`ps aux | grep ssh | grep -c $mp:127.0.0.1:$mp`
            # 查找打开的端口 可能较慢
            # ret=`netstat -a | grep -c "$JPROXY_SOCKS_PORT"`
            [[ $ret -gt 0 ]] && echo "Proxy is running." || echo "Proxy is not running."
            ;;
        "watch" )
            watch -n 1 "lsof -i:$JPROXY_SOCKS_PORT"
            ;;
        * )
            ;;
    esac
}