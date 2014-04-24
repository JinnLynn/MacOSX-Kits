
function kits_proxy_alive() {
    kits_ssh_proxy alive $JPROXY_SOCKS_PORT
    kits_privoxy alive
    kits_ssh_proxy alive $JPROXY_HOME_SOCKS_PORT
    # kits_squid alive
}

# 使用autossh 启用SSH动态端口转发（SOCKS代理）
# 命令形式：
#   kits_ssh_proxy [start|restart] SOCKS_PORT [USERNAME@]SSH_SERVER [--global]
#   kits_ssh_proxy [stop|alive|watch] SOCKS_PORT
# autossh的监控端口 = SOCKS_PORT + 50000 因此SOCKS_PORT<=9999
#! autossh还有一个接收端口，不指定默认是监控端口+1 见 man autossh中关于 -M 参数的描述
#! 因此由于接收端口的存在 不能同时打开相邻的动态端口
#! 如：9526 9527同时进行动态端口转发就不行
#! 因9526使用59527作为接收端口 而9527亦使用59527做监控端口
function kits_ssh_proxy() {
    [[ -z $(which autossh) ]] && echo "ERROR: autossh missing." && return 127
    [[ $# -lt 1 ]] && echo "ERROR: arguments missing." && return 127
    port=$([[ -z "$2" ]] && echo $JPROXY_SOCKS_PORT || echo $2)
    [[ ! $port -gt 1024 || $port -gt 9999 ]] 2>/dev/null && echo "SOCKS端口只能是数字且在1025-9999之间" && return 127
    mp=$((50000+$port))
    case "$1" in
        "start" | "restart" )
            srv=$([[ -z "$3" ]] && echo $JPROXY_SRV || echo $3)
            kits_ssh_proxy stop $port
            _kits_free_port $mp
            opt="-fN"
            [[ "$4" == "--global" ]] && opt="$opt -g"
            autossh -M $mp $opt -D $port $srv
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
            [[ $ret -gt 0 ]]; _kits_check "autossh[$mp]"
            ret=`lsof -i:$port | grep -c LISTEN`
            [[ $ret -gt 0 ]]; _kits_check "SOCKS5[127.0.0.1:$port]"
            ;;
        "watch" )
            # watch -n 1 "lsof -i:$JPROXY_SOCKS_PORT"
            python $KITS/python/port-traffic-monitor.py $port
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