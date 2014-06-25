
# 重置SSH相关
kits_ssh_reset() {
    echo "列出当前系统秘钥..."
    ssh-add -l
    echo "删除所有秘钥..."
    ssh-add -D
    echo "删除known_hosts..."
    rm -rf ~/.ssh/known_hosts
    echo "清除可能存在的无用SSH_AUTH_SOCK..."
    echo "当前SSH_AUTH_SOCK值: $SSH_AUTH_SOCK"
    local i
    for i in $(ls /tmp/launch-*/Listeners); do
        if [[ "$i" != "$SSH_AUTH_SOCK" ]]; then
            rm -rf $(dirname $i)
            echo "${i} was removed."
        fi
    done
    echo '重新安装秘钥...'
    for i in $JSSH_KEYS; do
        # 安装jkey时自动从钥匙串获取密码并输入
        if [[ ! -z "$(echo $i | grep jkey)" ]]; then
            password=$(kits_keychain_password "$i")
            expect -c "
                spawn ssh-add $i
                expect \"passphrase\"
                send \"$password\r\"
                expect eof
            "
        else
            ssh-add $i
        fi

    done
}

# 端口转发
# close PORT 关闭端口
# local PORT:HOST:HOSTPORT [SSH_HOST[:SSH_PORT]]
# remote PORT:HOST:HOSTPORT [SSH_HOST[:SSH_PORT]]
# dynamic PORT [SSH_HOST]
# SSH_HOST可选 默认 $JHOME 
# SSH_PORT 默认 $JHOME_SSH_PORT 
kits_ssh_port_forward() {
    [[ -z "$1" || -z "$2" ]] && echo "至少需要两个参数。" && return 1
    local port=`echo $2 | awk -F ':' '{print $1}'`
    local ssh_host=$(echo "$3" | awk -F ':' '{print $1}')
    local ssh_port=$(echo "$3" | awk -F ':' '{print $2}')
    [[ -z "$ssh_host" ]] && ssh_host="$JHOME"
    [[ -z "$ssh_port" ]] && ssh_port="22"
    [[ $ssh_host == $JHOME ]] && ssh_port="$JHOME_SSH_PORT"
    case "$1" in
        "local" )
            _kits_free_port $port
            ssh -fN -L $2 -p $ssh_port $ssh_host
            ;;
        "remote" )
            _kits_free_port $port
            ssh -fN -R $2 -p $ssh_port $ssh_host
            ;;
        "dynamic" )
            _kits_free_port $port
            ssh -fN -D $port -p $ssh_port $ssh_host
            ;;
        "close" )
            _kits_free_port $port
            ;;
        * )
            echo "参数错误。"
            ;;
    esac
}