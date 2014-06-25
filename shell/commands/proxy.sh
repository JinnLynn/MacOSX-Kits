
kits_proxy_alive() {
    kits_home_socks alive
    kits_goagent alive
}

kits_proxy_test() {
    kits_home_socks test
    kits_goagent test 
}

# 使用autossh 启用SSH动态端口转发（SOCKS代理）
# 命令形式：
#   kits_ssh_proxy [start|restart] SOCKS_PORT [USERNAME@]SSH_SERVER [--global]
#   kits_ssh_proxy [stop|alive|watch] SOCKS_PORT
# autossh的监控端口 = SOCKS_PORT + 50000 因此SOCKS_PORT<=9999
#! autossh还有一个echo_port，默认是监控端口+1 见 man autossh中关于 -M 参数的描述
#! 因此由于接收端口的存在 不能同时打开相邻的动态端口
#! 如：9526 9527同时进行动态端口转发就不行
#! 因9526使用59527作为接收端口 而9527亦使用59527做监控端口
kits_ssh_proxy() {
    [[ -z $(which autossh) ]] && echo "ERROR: autossh missing." && return 127
    [[ $# -lt 1 ]] && echo "ERROR: arguments missing." && return 127
    port=$([[ -z "$2" ]] && echo $JPROXY_SOCKS_PORT || echo $2)
    [[ ! $port -gt 1024 || $port -gt 9999 ]] 2>/dev/null && echo "SOCKS端口只能是数字且在1025-9999之间" && return 127
    mp=$((50000+$port))
    ep=$((1+$mp))
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
            _kits_free_port $ep
            _kits_free_port $port
            ;;
        "alive" )
            # 查找autossh进程
            _kits_is_port_listen $ep; _kits_check "autossh[$mp>$ep]"
            _kits_is_port_listen $port; _kits_check "SOCKS5[$port]"
            ;;
        "watch" )
            # watch -n 1 "lsof -i:$JPROXY_SOCKS_PORT"
            python $KITS/python/port-traffic-monitor.py $port
            ;;
        "test" )
            curl -sI -m 1 --socks5 "127.0.0.1:$port" http://www.baidu.com > /dev/null
            _kits_check "SOCKS5[$port]"
            ;;
        * )
            echo "ERROR. Usage: <start|stop|restart|watch|alive|test>"
            ;;
    esac
}

# GoAgent控制
kits_goagent() {
    log_file=$KITS_LOG/goagent.log
    script_file="$KITS/extra/goagent/proxy.py"

    port=$PROXY_GOAGENT_PORT

    case "$1" in
        "start" | "restart" )
            kits_goagent stop
            sleep 2
            nohup python $script_file >$log_file 2>&1 &
            ;;
        "start-frontend" )
            kits_goagent stop
            sleep 2
            python $script_file
            ;;
        "stop" )
            _kits_free_port $port
            ;;
        "alive" )
            _kits_is_port_listen $port
            _kits_check "GoAgent[$port]"
            ;;
        "keep-alive" )
            _kits_is_port_listen $port || kits_goagent restart
            ;;
        "log" )
            tail -f $log_file
            ;;
        "test" )
            # goagent 连接可能需要较长时间 不宜设置max-time
            curl -sI --proxy "127.0.0.1:$port" http://www.baidu.com > /dev/null
            _kits_check "GoAgent[$port]"
            ;;
        * )
            echo "ERROR. Usage: <start|stop|restart|alive|keep-alive|log|test>"
            ;;
    esac
}

# 将Home的socks代理转发到本地
kits_home_socks() {
    port=$PROXY_SOCKS_PORT
    mp=$((50000+$port))
    ep=$(($mp+1))
    case "$1" in
        "start" | "restart" )
            kits_home_socks stop
            sleep 2
            autossh -M $mp -fNg -L $port:127.0.0.1:$port -p $JHOME_SSH_PORT $JHOME
            ;;
        "stop" )
            _kits_free_port $ep
            _kits_free_port $port
            ;;
        "alive" )
            _kits_is_port_listen $ep; _kits_check "autossh[$mp>$ep]"
            _kits_is_port_listen $port; _kits_check "SOCKS5[$port]"
            ;;
        "keep-alive" )
            _kits_is_port_listen $port || kits_home_socks restart
            ;;
        "test" )
            curl -sI -m 1 --socks5 "127.0.0.1:$port" http://www.baidu.com > /dev/null
            _kits_check "SOCKS5[$port]"
            ;;
        * )
            echo "ERROR, Usage: <start|stop|restart|alive|keep-alive|test>"
            ;;
    esac
}

# privoxy
kits_privoxy() {
    cfg=$KITS/config/privoxy
    port=$(cat $cfg | grep listen-address | awk -F ":" '{print $2}')
    [[ -z "$port" ]] && echo "Port missing." && return 1
    case "$1" in
        "start" | "restart" )
            kits_privoxy stop
            sleep 0.5
            privoxy $cfg
            ;;
        "stop" )
            _kits_free_port $port
            ;;
        "alive" )
            _kits_is_port_listen $port; _kits_check "privoxy[$port]"
            ;;
        "keep-alive" )
            _kits_is_port_listen $port || kits_privoxy restart
            ;;
        "test" )
            curl -sI -m 1 --proxy "127.0.0.1:$port" http://www.baidu.com > /dev/null
            _kits_check "privoxy[$port]"
            ;;
        * )
            echo "ERROR, Usage: <start|stop|restart|alive|keep-alive|test>"
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