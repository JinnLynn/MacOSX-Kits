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

# 输出检查结果字符串
# 使用方法: 判断语句; _kits_check "说明文字"
# 如: [[ 0 -eq 0 ]]; _kits_check "0=0?"
function _kits_check() {
    ret=$?
    ok="\033[32m✔\033[39m"
    fail="\033[31m✘\033[39m"
    for (( i = 0; i < 40; i++ )); do echo -n " "; done
    [[ $ret -eq 0 ]] && echo -en "$ok" || echo -en "$fail"
    [[ ! -z "$1" ]] && echo -e "\r$1"
}

function _kits_doforever() {
    [[ -z "$1" || -z "$2" ]] && echo "Usage: <DELAY> <COMMAND>" && return 1
    [[ ! "$1" -gt 0 ]] && echo "DELAY must be number and greater than 0." && return 1
    while true; do
        $2
        echo -e "\n\033[32mWait $1 second(s) before do next...\033[39m\n"
        sleep $1
    done
}

# 获取一个未使用的网络端口
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