# 使用autossh 启用SSH动态端口转发（SOCKS代理）
# 命令形式：
#   kits_ssh_proxy [start|restart] SOCKS_PORT [USERNAME@]SSH_SERVER
#   kits_ssh_proxy [stop|alive|watch] SOCKS_PORT
# autossh的监控端口 = SOCKS_PORT + 50000 因此SOCKS_PORT<=9999
#! autossh还有一个echo_port，默认是监控端口+1 见 man autossh中关于 -M 参数的描述
#! 因此由于接收端口的存在 不能同时打开相邻的动态端口
#! 如：9526 9527同时进行动态端口转发就不行
#! 因9526使用59527作为接收端口 而9527亦使用59527做监控端口
kits_ssh_proxy() {
    [[ -z $(which autossh) ]] && echo "ERROR: autossh missing." && return 127
    [[ $# -lt 1 ]] && echo "ERROR: arguments missing." && return 127
    local port=$([[ -z "$2" ]] && echo $PROXY_SOCKS_PORT || echo $2)
    [[ ! $port -gt 1024 || $port -gt 9999 ]] 2>/dev/null && echo "SOCKS端口只能是数字且在1025-9999之间" && return 127
    case "$1" in
        "start" | "restart" )
            local srv=$([[ -z "$3" ]] && echo $PROXY_SRV || echo $3)
            $FUNCNAME stop
            local opt="-fN"
            [[ $PROXY_GLOBAL ]] && opt="$opt -g"
            autossh -M $(kits_random 50000 60000) $opt -i $PROXY_KEY -D $port $srv
            ;;
        "stop" )
            _kits_kill_pid $AUTOSSH_PIDFILE
            _kits_free_port $port
            ;;
        "alive" )
            local mp=$(ps ax | grep "autossh -M" | grep -v grep | grep "$(cat $AUTOSSH_PIDFILE 2>/dev/null)" | awk '{print $7}')
            local msg="autossh"
            [[ -n "$mp" ]] && msg="$msg[$mp]"
            _kits_pid_exists $AUTOSSH_PIDFILE; _kits_check "$msg"
            _kits_is_port_listen $port; _kits_check "SOCKS5[$port]"
            ;;
        "keep-alive" )
            _kits_is_port_listen $port || $FUNCNAME restart
            ;;
        "watch" )
            # watch -n 1 "lsof -i:$JPROXY_SOCKS_PORT"
            python $KITS/python/port-traffic-monitor.py $port
            ;;
        "test" )
            # 勿用google
            ret=$(curl -s -m 5 --socks5 "127.0.0.1:$port" http://ipv4.wtfismyip.com/text)
            _kits_check "SOCKS5[$ret->$port]"
            ;;
        * )
            echo "ERROR. Usage: <start|stop|restart|watch|alive|test>"
            ;;
    esac
}

kits_polipo() {
    ! _kits_cmd_exists polipo && echo 'Polipo missing.' && return 1

    local port="$PROXY_HTTP_PORT"
    local socks_port="$PROXY_SOCKS_PORT"

    case "$1" in
        "start" | "restart" )
            $FUNCNAME stop
            sleep 0.5
            polipo proxyAddress=::0 proxyPort=$port socksParentProxy=127.0.0.1:$socks_port socksProxyType=socks5 daemonise=true disableLocalInterface=true logFile=$KITS_LOG/polipo.log
            ;;
        "stop" )
            _kits_free_port $port
            ;;
        "alive" )
            _kits_is_port_listen $port; _kits_check "Polipo[$port]"
            ;;
        "keep-alive" )
            _kits_is_port_listen $port || $FUNCNAME restart
            ;;
        "test" )
            ret=$(curl -s -m 5 --proxy "127.0.0.1:$port" http://ipv4.wtfismyip.com/text)
            _kits_check "Polipo[$ret->$port]"
            ;;
        * )
            echo "ERROR, Usage: <start|stop|restart|alive|keep-alive|test>"
            ;;
    esac
}

kits_tor() {
    ! _kits_cmd_exists tor && echo 'Tor missing.' && return 1

    local port=$TOR_SOCKS_PORT
    local ctrl_port=$TOR_CONTROL_PORT

    local tor_data="$KITS_TMP/tor-$port.data"
    local tor_rc="$tor_data/torrc"
    local tor_log="$KITS_LOG/tor-$port.log"
    
    local pluggable_transports="/Applications/TorBrowser.app/TorBrowser/Tor/PluggableTransports"
    [[ ! -d "$pluggable_transports" ]] && pluggable_transports="$KITS/extra/Tor/PluggableTransports"

    local circuit=$(expect -c "
            spawn telnet 127.0.0.1 $ctrl_port
            send \"AUTHENTICATE\r\"
            expect \"250 OK\"
            send \"GETINFO circuit-status\r\"
            set results $expect_out(buffer)
            send \"quit\r\"
            expect eof" 2>/dev/null | grep BUILT)

    case "$1" in
        "start" | "restart" )
            $FUNCNAME stop
            sleep 1
            [[ ! -d "$tor_data" ]] && mkdir -p "$tor_data"
            # 生成临时配置文件
            echo -e "# this is a temporary torrc file.\n" >$tor_rc
            echo "SocksPort $port" >>$tor_rc
            [[ $TOR_GLOBAL ]] && echo "SOCKSListenAddress 0.0.0.0" >>$tor_rc
            echo "ControlPort $ctrl_port" >>$tor_rc
            echo "DataDirectory $tor_data" >>$tor_rc
            echo "Log notice file $tor_log" >>$tor_rc
            echo "DisableDebuggerAttachment 0" >>$tor_rc
            # echo "StrictNodes 1" >>$tor_rc
            # echo "ExitNodes {jp},{kr},{sg},{us},{mo},{hk}" >>$tor_rc
            echo "ClientTransportPlugin obfs2,obfs3,obfs4,scramblesuit exec $pluggable_transports/obfs4proxy" >>$tor_rc
            # echo "ClientTransportPlugin meek exec $pluggable_transports/meek-client-torbrowser -- $pluggable_transports/meek-client" >>$tor_rc
            local len=${#TOR_BRIDGE[@]}
            if [[ $len -gt 0 ]]; then
                echo "UseBridges 1"  >>$tor_rc
                for (( i = 0; i < $len; i++ )); do
                    echo "Bridge ${TOR_BRIDGE[$i]}"  >>$tor_rc
                done
            fi
            echo "RunAsDaemon 1" >>$tor_rc
            tor -f "$tor_rc" 1>/dev/null
            ;;
        "stop" )
            _kits_free_port $port
            echo -e "\n--------------------\n" >>$tor_log
            ;;
        "alive" )
            [[ -n "$circuit" ]]; _kits_check "Tor[$port]"
            ;;
        "keep-alive" )
            _kits_is_port_listen $port || $FUNCNAME restart
            ;;
        "watch" )
            ! _kits_cmd_exists arm && echo 'arm missing.' && return 1 || arm -i $ctrl_port -e nc
            ;;
        "test" )
            curl -sI -m 1 --socks5 "127.0.0.1:$port" http://www.baidu.com > /dev/null
            _kits_check "SOCKS5[$port]"
            ;;
        * )
            echo "ERROR. Usage: <start|stop|restart|alive>"
    esac
}

# privoxy
kits_privoxy() {
    local cfg=$KITS/config/privoxy
    local port=$(cat $cfg | grep listen-address | awk -F ":" '{print $2}')
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

# 将Home的socks代理转发到本地
kits_home_socks() {
    local port=$PROXY_SOCKS_PORT
    local mp=$((50000+$port))
    local ep=$(($mp+1))
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

# squid相关控制
kits_squid() {
    local pid=$(ps ax | grep "squid" | awk '{print $1, $5}' | grep "(squid)" | awk '{print $1}')
    # 基于SquidMan生成的配置文件
    local conf=~/Library/Preferences/squid.conf

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

# GoAgent控制
kits_goagent() {
    local log_file=$KITS_LOG/goagent.log
    local script_file="$KITS/extra/goagent/proxy.py"

    local port=$PROXY_GOAGENT_PORT

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