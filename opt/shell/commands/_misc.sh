# 循环执行命令
kits_doforever() {
    [[ -z "$1" || -z "$2" ]] && echo "ERROR. Usage: <DELAY> <COMMAND>" && return 1
    [[ ! "$1" -gt 0 ]] && echo "ERROR. DELAY must be number and greater than 0." && return 1
    local count=0
    local delay=$1
    while true; do
        count=$(($count+1))
        _kits_color_text blue "--- Run Count: $count ---"
        $2
        echo ""
        for (( i = 0; i < $delay; i++ )); do
            _kits_clear_line
            _kits_green_text_inline "Wait $(($delay-$i)) second(s) before do next..."
            sleep 1
        done
        _kits_clear_line
    done
}

# 使用Preview | more | dash打开man内容
kits_man() {
    local error="ERROR. Usage: kits_man [-p|-m|-d] COMMAND_NAME"
    [[ -z "$2" ]] && echo "$error" && return 1
    case $1 in
        "-p" )
            man -t $2 | open -f -a /Applications/Preview.app
        ;;
        "-m" )
            man $2 | more
        ;;
        "-d" )
            open "dash://man:$2"
        ;;
        * )
            echo $error
        ;;
    esac
}

# 别名查找
kits_alias_find() {
   alias | awk -F '=' {'print $1'} | awk {'print $2'} | grep "$1"
}

# 从钥匙串获取密码 参数 account
kits_keychain_password() {
    [[ -z "$1" ]] && return
    local password=$(security find-generic-password -ga "$1" 2>&1 >/dev/null | cut -d '"' -f 2)
    echo -n $password
}

# 时间
kits_time() {
    case "$1" in
        "-d" | "date" )
            date +%Y-%m-%d
            ;;
        "-t" | "time" )
            date +%H:%M:%S
            ;;
        "-s" | "timestamp" )
            date +%Y%m%d%H%M%S
            ;;
        * )
            date +%Y-%m-%d\ %H:%M:%S
            ;;
    esac
}

kits_log() {
    local msg="$1"
    local logfile="$KITS_LOG/$(kits_time -d).log"
    [[ ! -z "$2" ]] && logfile="$2"
    [[ ! -f "$logfile" ]] && touch "$logfile" && chmod -R 777 "$logfile"
    [[ ! -z "$1" ]] && echo "$(kits_time)[$(whoami)]: $msg" >> $logfile
}

kits_random() {
    local min=0
    [[ ! -z "$1" ]] && min=$1
    local max=100
    [[ ! -z "$2" ]] && max=$2
    awk -v min=$min -v max=$max 'BEGIN{srand(); print int(min+rand()*(max-min+1))}'
}