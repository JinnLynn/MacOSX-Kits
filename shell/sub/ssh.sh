
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
            autossh -M $mp -f -N -D $JPROXY_SOCKS_PORT -i "$JPROXY_SERVER_KEY" $JPROXY_SERVER_USR@$JPROXY_SERVER
            ;;
        "stop" )
            # 杀死SSH进程
            for p in `ps aux | grep ssh | grep $mp:127.0.0.1:$mp | awk '{print $2}'`; do 
                [[ ! -z "$p" ]] && kill -9 $p
            done
            # 如果SSH没有成功连接, 前述的进程将不存在，需手动杀死autossh进程
            for p in `ps aux | grep autossh | grep $mp | awk '{print $2}'`; do 
                [[ ! -z "$p" ]] && kill -9 $p
            done
            ;;
        "alive" )
            # 查找autossh进程
            ret=`ps aux | grep autossh | grep -c $mp`
            [[ $ret -gt 0 ]]; _kits_check "autossh"
            ret=`lsof -i:$JPROXY_SOCKS_PORT`
            [[ ! -z "$ret" ]]; _kits_check "SOCKS[127.0.0.1:$JPROXY_SOCKS_PORT]"
            ;;
        "watch" )
            watch -n 1 "lsof -i:$JPROXY_SOCKS_PORT"
            ;;
        * )
            ;;
    esac
}