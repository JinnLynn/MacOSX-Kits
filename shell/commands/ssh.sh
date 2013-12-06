
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
    for i in $JSSH_KEYS; do
        ssh-add $i
    done
}

# 端口转发
# close PORT 关闭端口
# local PORT:HOST:HOSTPORT [SSH_HOST]
# remote PORT:HOST:HOSTPORT [SSH_HOST]
# dynamic PORT [SSH_HOST]
# SSH_HOST可选 默认 $JHOME
function kits_ssh_port_forward() {
    [[ -z "$1" || -z "$2" ]] && echo "至少需要两个参数。" && return 1
    port=`echo $2 | awk -F ':' '{print $1}'`
    ssh_host="$3"
    [[ -z "$ssh_host" ]] && ssh_host="$JHOME"
    case "$1" in
        "local" )
            _kits_free_port $port
            ssh -fN -L $2 $ssh_host
            ;;
        "remote" )
            _kits_free_port $port
            ssh -fN -R $2 $ssh_host
            ;;
        "dynamic" )
            _kits_free_port $port
            ssh -fN -D $port $ssh_host
            ;;
        "close" )
            _kits_free_port $port
            ;;
        * )
            echo "参数错误。"
            ;;
    esac
}