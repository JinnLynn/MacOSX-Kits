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
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: <DELAY> <COMMAND>"
        exit
    fi

    while true;
        do $2
        sleep $1
    done
}