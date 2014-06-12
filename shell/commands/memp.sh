
# 进程是否存在
# 参数可以是pid或pid文件
_kits_is_process_exists() {
    [[ -z "$1" ]] && return 1
    local pid=$([[ -f "$1" ]] && cat "$1" || echo "$1")
    ps -p "$pid" 1>/dev/null 2>&1
}

# 杀进程
# 参数可以是pid或pid文件
_kits_kill_process() {
    [[ -z "$1" ]] && return 1
    local pid=$([[ -f "$1" ]] && cat "$1" || echo "$1")
    # 先正常terminate 不行强制kill
    kill $pid 1>/dev/null 2>&1 || kill -9 $pid 1>/dev/null 2>&1
}

_kits_is_cmd_missing() {
    [[ -z "$1" ]] && return 0
    which "$1" >/dev/null 2>&1 && return 1 || return 0
}

kits_nginx() {
    _kits_is_cmd_missing nginx && echo "nginx missing." && return 1
    local config_file=$KITS/config/nginx/nginx.conf
    local pid_file=/usr/local/var/run/nginx.pid
    case "$1" in
        "start" | "restart")
            _kits_is_process_exists "$pid_file" && nginx -s stop && sleep 2
            nginx -c $config_file
            ;;
        "reload" )
            _kits_is_process_exists "$pid_file" && nginx -s reload || echo "Nginx is not running."
            ;;
        "stop" )
            _kits_is_process_exists "$pid_file" && nginx -s stop || echo "Nginx is not running."
            ;;
        "alive" )
            _kits_is_process_exists "$pid_file"; _kits_check "Nginx"
            ;;
        * )
            echo "ERROR. USAGE: start|restart|reload|stop|alive"
            ;;
    esac
}

kits_mysql() {
    _kits_is_cmd_missing mysql.server && echo "mysql missing." && return 1
    case "$1" in
        "start" | "restart" )
            mysql.server restart 1>/dev/null 2>&1
            ;;
        "reload" )
            mysql.server reload 1>/dev/null 2>&1
            ;;
        "stop" )
            mysql.server stop 1>/dev/null 2>&1
            ;;
        "alive" )
            local ret=$(mysql.server status | grep -c SUCCESS)
            [[ $ret -gt 0 ]]; _kits_check "MySQL"
            ;;
        * )
            echo "ERROR. USAGE: start|restart|reload|stop|alive"
            ;;
    esac
}

kits_php-fpm() {
    _kits_is_cmd_missing php-fpm && echo "php-fpm missing." && return 1
    local fpm_config="/usr/local/etc/php/5.5/php-fpm.conf"
    local pid_file="/usr/local/var/run/php-fpm.pid"
    local log_file="$KITS_LOGPATH/php-fpm.log"
    case "$1" in
        "start" | "restart" | "reload" )
            _kits_is_process_exists "$pid_file" && kits_php-fpm stop
            php-fpm -D --fpm-config $fpm_config --pid $pid_file 1>$log_file 2>&1
            ;;
        "stop" )
            _kits_is_process_exists "$pid_file" && _kits_kill_process "$pid_file" || echo "PHP-FPM is not running."
            ;;
        "alive" )
            _kits_is_process_exists "$pid_file"; _kits_check "PHP-FPM"
            ;;
        * )
            echo "ERROR. USAGE: start|restart|reload|stop|alive"
            ;;
    esac

}

kits_memp() {
    case "$1" in
        "start" | "restart" )
            kits_nginx restart
            kits_mysql restart
            kits_php-fpm restart
            ;;
        "reload" )
            kits_nginx reload
            kits_mysql reload
            kits_php-fpm reload
            ;;
        "stop" )
            kits_nginx stop
            kits_mysql stop
            kits_php-fpm stop
            ;;
        "alive" )
            kits_nginx alive
            kits_mysql alive
            kits_php-fpm alive
            ;;
        * )
            echo "ERROR. USAGE: start|restart|reload|stop|alive"
            ;;
    esac
}