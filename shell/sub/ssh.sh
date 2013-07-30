
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
    ssh-add $JCP_KEY
}

# 本地端口转发
# 参数 open|close 本地端口:远程ip:远程端口
function kits_home_local_port_forward() {
    [[ -z "$1" || -z "$2" ]] && return 1
    port=`echo $2 | awk -F ':' '{print $1}'`
    case "$1" in
        "open" )
            _kits_free_port $port
            ssh -fN -L $2 $JHOME
            ;;
        "close" )
            _kits_free_port $port
            ;;
    esac
}