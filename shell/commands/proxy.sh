
kits_proxy_alive() {
    _kits_is_port_connectable $PROXY_REMOTE_SOCKS_HOST $PROXY_REMOTE_SOCKS_PORT
    _kits_check "SOCKS5[$PROXY_REMOTE_SOCKS_HOST:$PROXY_REMOTE_SOCKS_PORT]"
    kits_goagent alive
    kits_ssh_proxy alive $JPROXY_SOCKS_PORT
    kits_ssh_proxy alive $JPROXY_HOME_SOCKS_PORT
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
kits_ssh_proxy() {
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
            _kits_is_port_listen $mp; _kits_check "autossh[$mp]"
            ret=`lsof -i:$port | grep -c LISTEN`
            _kits_is_port_listen $port; _kits_check "SOCKS5[127.0.0.1:$port]"
            ;;
        "watch" )
            # watch -n 1 "lsof -i:$JPROXY_SOCKS_PORT"
            python $KITS/python/port-traffic-monitor.py $port
            ;;
        * )
            echo "ERROR. Usage: <start|stop|restart|watch|alive>"
            ;;
    esac
}

# GoAgent控制
kits_goagent() {
    log_file=$KITS_LOGPATH/goagent.log
    script_file="$KITS/extra/goagent/proxy.py"

    port=$KITS_GOAGENT_PORT

    case "$1" in
        "start" )
            if [[ -z "$KITS_TASK_RUNNING" ]]; then
                _kits_is_port_listen $port || nohup python $script_file > $log_file 2>&1 &
            else
                # 计划任务中执行时不能放入后台 WHY?
                _kits_is_port_listen $port || python $script_file > $log_file 2>&1
            fi
            ;;
        "stop" )
            _kits_free_port $port > /dev/null 2>&1
            ;;
        "restart" )
            kits_goagent stop
            sleep 2
            kits_goagent start
            ;;
        "alive" )
            _kits_is_port_listen $port
            _kits_check "GoAgent[127.0.0.1:$port]"
            ;;
        "keep-alive" )
            _kits_is_port_listen $port || kits_goagent restart
            ;;
        "log" )
            tail -f $log_file
            ;;
        * )
            echo "ERROR. Usage: <start|stop|restart|alive|keep-alive|log>"
            ;;
    esac
}

# privoxy
kits_privoxy() {
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
kits_squid() {
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