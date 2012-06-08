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
    res=""
    pushd /Applications/MAMP/bin/ > /dev/null
    if [[ "$1" = 'start' ]]; then
        ./start.sh
        res="MAMP started."
    elif [[ "$1" = 'stop' ]]; then
        ./stop.sh
        res="MAMP stopped."
    elif [[ "$1" = 'restart' ]]; then
        ./stop.sh
        sleep 1
        ./start.sh
        res="MAMP restarted."
    elif [[ "$1" = 'isrunning' ]]; then
        hres="Apache is not running."
        mres="Mysql is not running."
        if [[ $(ps -ec | grep -c "httpd") -gt 0 ]]; then 
            hres="Apache is running."
        fi
        if [[ $(ps -ec | grep -c "mysqld") -gt 0 ]]; then
            mres="Mysql is running."
        fi
        res="$hres\n$mres"
    else
        res="ERROR. Usage: <start|stop|restart|isrunning>"
    fi 
    popd > /dev/null
    echo -e "$res"
}

# WIFI相关控制
function wifi() {
    # WIFI networkservice
    wifins="Wi-Fi"
    # WIFI device name
    wifidn="en1"
    case "$1" in
        "power" )
            case "$2" in
                "off"|"on" )
                    networksetup -setairportpower "$wifidn" $2
                ;;
                "reset" )
                    wifi power off
                    sleep 1
                    wifi power on
                ;;
                * )
                    echo "ERROR."
                ;;
            esac
        ;;
        "location"|"loc" )
            loc=$2
            if [[ "$loc" = 'auto' ]]; then loc="Automatic"; fi
            networksetup -switchtolocation "$loc" >/dev/null
            res
        ;;
        "proxy" )
            case "$2" in
                "all" )
                    networksetup -setsocksfirewallproxy "$wifins" "$JPROXYSOCKSHOST" "$JPROXYSOCKSPORT" off
                    networksetup -setsocksfirewallproxystate "$wifins" on
                    networksetup -setautoproxystate "$wifins" off
                    ;;
                "auto" )
                    networksetup -setsocksfirewallproxystate "$wifins" off
                    networksetup -setautoproxyurl "$wifins" "$JPACURL"
                    ;;
                "off" )
                    networksetup -setsocksfirewallproxystate "$wifins" off
                    networksetup -setautoproxystate "$wifins" off
                    ;;
                * )
                    echo "ERROR."
                ;;
            esac
        ;;
        "ip" )
            case "$2" in
                "manual" )
                    if [[ -z "$3" || -z "$4" || -z "$5" ]]; then
                        echo "ERROR. Missing args."
                        exit
                    fi
                    networksetup -setmanual "$wifins" "$3" "$4" "$5"
                    ;;
                "dhcp" )
                    networksetup -setdhcp "$wifins"
                    ;;
                * )
                    echo "ERROR."
                ;;
            esac
        ;;
        "info" )
            #echo "Location: $(networksetup -getcurrentlocation)"
            #networksetup -getinfo "$wifins"
            networksetup -getautoproxyurl "$wifins"
        ;;
        * )
            echo "ERROR. Usage: <power|location|loc|proxy|ip> [ARGS]"
        ;;
    esac
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
    'wifi' )
        wifi $2 $3 $4 $5 $6
        ;;
    * )
        echo "ERROR."
        exit 1
        ;;
esac