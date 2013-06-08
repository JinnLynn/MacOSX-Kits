# squid相关控制

function kits_squid() {
    pid=$(ps ax | grep "squid" | awk '{print $1, $5}' | grep "(squid)" | awk '{print $1}')
    # 基于SquidMan生成的配置文件
    conf=~/Library/Preferences/squid.conf

    case "$1" in
        "start" )
            /usr/local/squid/sbin/squid -f $conf
            ;;
        "stop" )
            [[ -n "$pid" ]] && kill -9 $pid
            ;;
        "restart" )
            squid.sh stop
            sleep 1
            squid.sh start
            ;;
        "alive" )
            [[ -n "$pid" ]]; _kits_check "Squid"
            ;;
        * )
            echo "ERROR. Usage: <start|stop|restart|alive>"
    esac
}