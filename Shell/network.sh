# 重置SSH相关
function ssh_reset() {
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
}

# MAMP相关控制
function mamp() {
    mamp_bin="/Applications/MAMP/bin"
    if [[ "$1" = 'start' ]]; then
        $mamp_bin/startMysql.sh
        $mamp_bin/startApache.sh
    elif [[ "$1" = 'stop' ]]; then
        $mamp_bin/stopMysql.sh
        $mamp_bin/stopApache.sh
    elif [[ "$1" = 'restart' ]]; then
        $mamp_bin/stopMysql.sh
        $mamp_bin/stopApache.sh
        sleep 1
        $mamp_bin/startMysql.sh
        $mamp_bin/startApache.sh
    elif [[ -z "$1" ]]; then
        echo "ERROR. Usage: <start|stop|restart>"
        exit 1
    fi 
}

case "$1" in
    'ssh' )
        if [[ "$2" = 'reset' ]]; then
            ssh_reset
        fi
        ;;
    'mamp' )
        mamp $2
        ;;
    * )
        echo "ERROR."
        exit 1
        ;;
esac