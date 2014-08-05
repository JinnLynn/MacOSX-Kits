# 初始化launchd.plist
kits_launchd_init_(){
    [[ -z "$1" || -z "$2" || -z "$3" ]] && echo "error" && return 1
    local src=$1
    local plist=$2
    local dst=$3
    for i in $(ls $dst/$plist 2>/dev/null); do
        launchctl unload $i
    done
    rm -rf $dst/$plist
    cp $src/$plist $dst
    for i in $(ls $dst/$plist 2>/dev/null); do
        launchctl load $i
    done
}

kits_launchd_reload_() {
    [[ -z "$1" ]] && return 1
    for i in $(ls "$1" 2>/dev/null); do
        launchctl unload $i
        launchctl load $i
    done
}

kits_launchd_init() {
    kits_launchd_init_ "$KITS/config/launchd.plist" "net.jeeker.kits.*.plist" "$HOME/Library/LaunchAgents"
}

kits_launchd_reload() {
    kits_launchd_reload_ "$HOME/Library/LaunchAgents/net.jeeker.kits.*.plist"
}

kits_launchd_root_init() {
    kits_sudo_func kits_launchd_init_ "$KITS/config/launchd.plist" "net.jeeker.root.kits.*.plist" "/Library/LaunchDaemons"
}

kits_launchd_root_reload() {
    kits_sudo_func kits_launchd_reload_ "/Library/LaunchDaemons/net.jeeker.root.kits.*.plist"
}