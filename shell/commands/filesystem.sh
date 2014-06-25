#! 使用open .命令即可完成
# 在Finder中打开文件夹
# BUG: 当文件夹名如.git、.ssh时无法打开
# kits_finder_open() {
#     # 如果: 无参数取当前工作目录；是文件取其所在文件夹路径
#     folder=$1
#     if [[ -z "$folder" || "$folder" = '.' ]]; then
#         folder=$(pwd)
#     elif [[ -f "$folder" ]]; then
#         folder=$(dirname $folder)
#     elif [[ ! -d "$folder" ]]; then
#         echo "ERROR. directory not found."
#         exit
#     fi
#     # 转换为绝对路径
#     folder=$(cd $folder; pwd)
#     cmd=$(echo -n "tell application \"Finder\" to open folder { \"$folder\" }")
#     osascript -e "$cmd"
#     # 执行成功激活Finder
#     if [[ $? -eq 0 ]]; then
#         osascript -e 'tell application "Finder" to activate'
#     else
#         echo "something error. $folder"
#     fi
# }

# 在终端中打开Finder当前窗口所在目录
# 情况处理: Finder窗口只有一个直接进入; 多个，选择后进入
# 由于`cd`的原因调用命令所在脚本时必须 source FILENAME
kits_finder_to()
{
    ##
    # 直接执行下面的代码获取的窗口不一定是当前的Finder(在AppleScript editor中是可以的，WHY？)
    # path=$(osascript -e 'tell application "Finder" to get POSIX path of (target of front window as alias)')
    ##
    local win_num=1
    local win_count=$(osascript -e 'tell application "Finder" to get count of window')
    if [[ $win_count -eq 0 ]]; then
        echo "ERROR. NO Finder window found."
        return
    elif [[ $win_count -eq 1 ]]; then
        win_num=1
    else
        local count=1
        while [[ $count -le $win_count ]]; do
            cmd=$(echo -n "tell application \"Finder\" to get POSIX path of (folder of window $count as alias)")
            echo "$count. $(osascript -e "$cmd")"
            count=$((count+1))
        done
        echo -n "Which one: "
        read win_num
        # 数字检查
        expr $win_num + 0 1>/dev/null 2>&1
        if [[ $? -ne 0 || $win_num -le 0 || $win_num -gt $win_count ]]; then
            echo "input error."
            return
        fi
    fi
    local cmd=$(echo -n "tell application \"Finder\" to get POSIX path of (folder of window $win_num as alias)")
    cd "$(osascript -e "$cmd")"
    echo "go to $(pwd)"
}

# 路径跳转 不定参数
kits_to() {
    [[ -z "$1" ]] && pwd && return 1
    until [[ -z "$1" ]]; do
        cd "$1" 1>/dev/null 2>&1
        [[ $? -ne 0 ]] && echo "$1: No such directory." && pwd && return 1
        shift
    done
    pwd
}

# 路径跳转 并在finder中打开
kits_tof() {
    [[ -z "$1" ]] && open . && return 0
    [[ ! -d "$1" ]] && echo "$1: No such directory." && return 1
    pushd . > /dev/null
    until [[ -z "$1" ]]; do
        cd "$1" 1>/dev/null 2>&1
        [[ $? -ne 0 ]] && echo "$1: No such directory." && return 1
        shift
    done
    open .
    popd > /dev/null
}