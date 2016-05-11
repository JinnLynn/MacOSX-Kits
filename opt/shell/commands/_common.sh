# 输出颜色文字
# _kits_color_text COLOR TEXT
# 如: _kits_color_text green output_string 
_kits_color_text() {
    [[ -z "$1" || -z "$2" ]] && return
    local color="39m"
    case "$1" in
        "black" ) color="30m";; # 30:黑
        "red" ) color="31m";; # 31:红
        "green" ) color="32m";; # 32:绿
        "yellow" ) color="33m";; # 33:黄
        "blue" ) color="34m";; # 34:蓝色
        "purple" ) color="35m";; # 35:紫色
        "cyan" ) color="36m";; # 36:蓝绿色(青色)
        "gray" ) color="37m";; # 37:灰色
        * ) color="39m";; # 默认
    esac
    shift 
    echo -e "\033[$color$@\033[0m"
}

_kits_green_text() {
    _kits_color_text green $@
}

_kits_red_text() {
    _kits_color_text red $@
}

# 清空行
_kits_clear_line() {
    local columns
    [[ ! -z "$COLUMNS" ]] && columns="$COLUMNS" || columns=80
    [[ ! -z "$1" ]] && columns="$1"
    local o=$(for ki in $(seq $columns); do echo -n " "; done)
    echo -en "\r$o\r"
}

# 输出检查结果字符串
# 使用方法: 判断语句; _kits_check "说明文字"
# 如: [[ 0 -eq 0 ]]; _kits_check "0=0?"
_kits_check() {
    local ret=$?
    local s=$(for ki in $(seq 40); do echo -n " "; done)
    local judge=$([[ $ret -eq 0 ]] && _kits_green_text "✔" || _kits_red_text "✘")
    echo -e "$s$judge\r$1"
}

_kits_check_prefix() {
    local ret=$?
    local judge=$([[ $ret -eq 0 ]] && _kits_green_text "✔" || _kits_red_text "✘")
    echo -e "$judge  $1"
}

# 输出内容到stderr
_kits_echo_err() { 
    echo "$@" 1>&2; 
}

# 杀死进程 可以是进程ID或pid文件
_kits_kill_pid() {
    local pid=$1
    [[ -z "$pid" ]] && return 1
    [[ -f "$pid" ]] && pid=$(cat $pid)
    [[ ! -z "$pid" ]] && {
        kill $pid >/dev/null 2>&1 || kill -9 $pid >/dev/null 2>&1
    }
}

# 进程是否存在 可以是进程ID或pid文件
_kits_pid_exists() {
    local pid=$1
    [[ -z "$pid" ]] && return 1
    [[ -f "$pid" ]] && pid=$(cat $pid)
    [[ -z "$pid" ]] && return 1
    local find_pid=$(ps -ax | awk '{print $1}' | grep -e "^$pid$")
    [[ -z "$find_pid" ]] && return 1 || return 0
}

# 释放被占用的端口(kill 正在使用端口的进程)
_kits_free_port() {
    [[ -z "$1" ]] && return
    local pids=`lsof -i:$1 | grep LISTEN | awk '{print $2}'`
    local p
    for p in $pids; do
        _kits_kill_pid $p
    done
}

# 端口是否正在使用中
# $1 端口号
# $2 可选 使用该端口的命令
_kits_is_port_listen() {
    [[ -z "$1" ]] && return 1
    local ret
    [[ -z "$2" ]] && {
        ret=$(lsof -i:$1 | grep -c LISTEN)
    } || {
        ret=$(lsof -i:$1 | grep LISTEN | grep -c "^$2")
    }
    [[ $ret -gt 0 ]] && return 0 || return 1
}

# 端口是否可连接 可用于测试远程
_kits_is_port_connectable() {
    [[ -z "$1" ]] && return 1
    [[ -z "$2" ]] && return 1
    # nc 在某些无法连接的情况下速度很慢
    # nc -z -w 1 "$1" "$2" >/dev/null 2>&1
    $KITS/bin/port-check -t 1 "$1" "$2" | grep succeeded >/dev/null 2>&1
}

# 获取一个未使用的网络端口
# 使用 port=$(_kits_unused_port)
_kits_unused_port() {
    [[ -z "$JPORT_START" ]] && export JPORT_START="55000"
    while true; do
        JPORT_START=$(($JPORT_START+1))
        [[ -z `lsof -i:$JPORT_START` ]] && echo $JPORT_START && return
    done
}

# 命令是否存在
# _kits_cmd_exists CMD && echo "CMD exists." || echo "CMD missing."
# ! _kits_cmd_exists CMD && echo "CMD missing." && return 1
_kits_cmd_exists() {
    which $1 >/dev/null 2>&1 && return 0 || return 1
}

_kits_hr_bw() {
    # 是否数字
    [[ -z "$(echo "$1" | grep -s -E "^[0-9]+$")" ]] && return 1
    local bw=$1
    local units="B/s KB/s MB/s GB/s TB/s PB/s"
    for unit in $units; do
        # 获取整数部分，shell不支持浮点比较
        local int=$(echo $bw | awk -F. '{print $1}')
        if [[ $int -lt 1024 ]]; then
            echo $unit
            bw="$bw$unit"
            break
        else
            bw=$(echo $bw | awk 'BEGIN{OFMT="%.2f"}{print $1 / 1024}')
        fi
    done
    echo $bw
}

_kits_hr_size() {
    # 是否数字
    [[ -z "$(echo "$1" | grep -s -E "^[0-9]+$")" ]] && return 1
    local size=$1
    local units="B KB MB GB TB PB ZB"
    for unit in $units; do
        # 获取整数部分，shell不支持浮点比较
        local int=$(echo $size | awk -F. '{print $1}')
        if [[ $int -lt 1024 ]]; then
            size="$size$unit"
            break
        else
            size=$(echo $size | awk 'BEGIN{OFMT="%.2f"}{print $1 / 1024}')
        fi
    done
    echo $size
}

# 测试是否ip
_kits_is_ip() {
    local ip="$1"
    [[ ! "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] && return 1
    for i in {1..4}; do
        [[ $(echo "$ip" | cut -d. -f$i) -gt 255 ]] && return 1
    done
    return 0
}