# 获取文件或目录所在的文件夹
function _kits_get_dirpath() {
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
function _kits_symbolic_link() {
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
function _kits_color_text() {
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
function _kits_color_text_inline() {
    echo -en "$(_kits_color_text "$1" "$2")"
}

# 清空行
function _kits_clear_line() {
    columns=80
    [[ ! -z "$COLUMNS" ]] && columns="$COLUMNS"
    o=""
    for ki in $(seq $columns); do o="$o "; done
    echo -en "\r$o\r"
}

# 输出检查结果字符串
# 使用方法: 判断语句; _kits_check "说明文字"
# 如: [[ 0 -eq 0 ]]; _kits_check "0=0?"
function _kits_check() {
    ret=$?
    _kits_clear_line
    [[ $ret -eq 0 ]] && _kits_color_text_inline "✔" green || _kits_color_text_inline "✘" red
}
    [[ ! -z "$1" ]] && echo -e "\r$1"

# 获取一个未使用的网络端口
# 使用 port=$(_kits_unused_port)
function _kits_unused_port() {
    [[ -z "$JPORT_START" ]] && export JPORT_START="55000"
    while true; do
        JPORT_START=$(($JPORT_START+1))
        [[ -z `lsof -i:$JPORT_START` ]] && echo $JPORT_START && return
    done
}

# 释放被占用的端口(kill 正在使用端口的进程)
function _kits_free_port() {
    [[ -z "$1" ]] && return
    pid=`lsof -i:$1 | grep -m 1 $1 | awk '{print $2}'`
    [[ ! -z "$pid" ]] && kill -9 $pid
}