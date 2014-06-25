# 循环执行命令
kits_doforever() {
    [[ -z "$1" || -z "$2" ]] && echo "ERROR. Usage: <DELAY> <COMMAND>" && return 1
    [[ ! "$1" -gt 0 ]] && echo "ERROR. DELAY must be number and greater than 0." && return 1
    local count=0
    local delay=$1
    while true; do
        count=$(($count+1))
        _kits_color_text "--- Run Count: $count ---" blue
        $2
        echo ""
        for (( i = 0; i < $delay; i++ )); do
            _kits_clear_line
            _kits_color_text_inline "Wait $(($delay-$i)) second(s) before do next..." green
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

# 初始化launchd.plist
kits_launchd_init() {
    local src=$KITS/config/launchd.plist
    local dst=~/Library/LaunchAgents
    local plist=net.jeeker.kits.*.plist
    for i in $(ls $dst/$plist); do
        launchctl unload $i
    done
    rm -rf $dst/$plist
    cp $src/$plist $dst
    for i in $(ls $dst/$plist); do
        launchctl load $i
    done
}

kits_launchd_load() {
    for i in $(ls ~/Library/LaunchAgents/net.jeeker.kits.*.plist); do
        launchctl unload $i
        launchctl load $i
    done
}

# 从钥匙串获取密码 参数 account
kits_keychain_password() {
    [[ -z "$1" ]] && return
    local password=$(security find-generic-password -ga "$1" 2>&1 >/dev/null | cut -d '"' -f 2)
    echo -n $password
}