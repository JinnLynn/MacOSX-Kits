# 获取文件或目录所在的文件夹
_kits_get_dirpath() {
    file="$1"
    if [[ -z "$file" ]]; then
        echo ""
    fi
    if [[ -L $file ]]; then
        file=$(readlink $file)
    fi
    echo $(cd $(dirname $file); pwd)
}

# 软链接
# 如果目标是文件或文件夹 备份
# 如果目标已经是链接，删除，重新生成链接
_kits_symbolic_link() {
    if [[ ! -L "$2" ]]; then
        if [[ -f "$2" || -d "$2" ]]; then
            mv "$2" "$2-bak" 
            echo "BACKUP: "$2" -> "$2"-bak"
        fi
    elif [[ -L "$2" ]]; then
        rm -f "$2"
    fi
    ln -s "$1" "$2" 
}

# 输出颜色文字
# _kits_color_text TEXT [COLOR]
# 如: _kits_color_text output_string green
_kits_color_text() {
    [[ -z "$1" ]] && return
    case "$2" in
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
    echo -e "\033[$color$1\033[0m"
}

# 输出行内颜色文字
_kits_color_text_inline() {
    echo -en "$(_kits_color_text "$1" "$2")"
}

# 清空行
_kits_clear_line() {
    [[ ! -z "$COLUMNS" ]] && columns="$COLUMNS" || columns=80
    [[ ! -z "$1" ]] && columns="$1"
    o=$(for ki in $(seq $columns); do echo -n " "; done)
    echo -en "\r$o\r"
}

# 输出检查结果字符串
# 使用方法: 判断语句; _kits_check "说明文字"
# 如: [[ 0 -eq 0 ]]; _kits_check "0=0?"
_kits_check() {
    ret=$?
    s=$(for ki in $(seq 40); do echo -n " "; done)
    judge=$([[ $ret -eq 0 ]] && _kits_color_text_inline "✔" green || _kits_color_text_inline "✘" red)
    echo -e "$s$judge\r$1"
}

# 释放被占用的端口(kill 正在使用端口的进程)
_kits_free_port() {
    [[ -z "$1" ]] && return
    pids=`lsof -i:$1 | grep LISTEN | awk '{print $2}'`
    for p in $pids; do
        [[ ! -z "$p" ]] && kill -9 $p
    done
}

# 端口是否正在使用中
_kits_is_port_listen() {
    [[ -z "$1" ]] && return 1
    ret=$(lsof -i:$1 | grep -c LISTEN)
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