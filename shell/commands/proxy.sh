
function kits_proxy_alive() {
    kits_ssh_proxy alive
    kits_privoxy alive
    # kits_squid alive
}

# ssh代理
function kits_ssh_proxy() {
    mp="55000"
    case "$1" in
        "start" | "restart" )
            kits_ssh_proxy stop
            _kits_free_port $mp
            opt="-fN"
            [[ "$2" == "global" ]] && opt="$opt -g"
            autossh -M $mp $opt -D $JPROXY_SOCKS_PORT $JPROXY_SRV
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
            [[ ! -z "$ret" ]]; _kits_check "SOCKS5[127.0.0.1:$JPROXY_SOCKS_PORT]"
            ;;
        "watch" )
            # watch -n 1 "lsof -i:$JPROXY_SOCKS_PORT"
            python $KITS/python/port-traffic-monitor.py
            ;;
        * )
            ;;
    esac
}

# privoxy
function kits_privoxy() {
    cfg=$KITS/config/privoxy
    case "$1" in
        "start" | "restart" )
            kits_privoxy stop
            sleep 0.5
            privoxy $cfg
            ;;
        "stop" )
            for p in  `ps aux | grep "privoxy" | grep -v "grep" | awk '{print $2}'`; do
                [[ ! -z "$p" ]] && kill -9 $p
            done
            ;;
        "alive" )
            listen=`cat $cfg | grep "listen-address" | awk '{print $2}'`
            ret=`ps aux | grep -v "grep" | grep -c "privoxy"`
            [[ $ret -gt 0 ]]; _kits_check "privoxy[$listen]"
            ;;
    esac
}

# squid相关控制
function kits_squid() {
    pid=$(ps ax | grep "squid" | awk '{print $1, $5}' | grep "(squid)" | awk '{print $1}')
    # 基于SquidMan生成的配置文件
    conf=~/Library/Preferences/squid.conf

    case "$1" in
        "start" | "restart" )
            kits_squid stop
            sleep 1
            /usr/local/squid/sbin/squid -f $conf
            ;;
        "stop" )
            [[ -n "$pid" ]] && kill -9 $pid
            ;;
        "alive" )
            [[ -n "$pid" ]]; _kits_check "Squid"
            ;;
        * )
            echo "ERROR. Usage: <start|stop|restart|alive>"
    esac
}