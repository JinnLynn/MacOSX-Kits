kits_vpn() {
    local vpn_service=$([[ -z "$2" ]] && echo "VPN GFW" || echo $2)
    # scutil命令连接vpn时总是要secret key，不管是否已配置
    local vpn_secret=$([[ -z "$3" ]] && echo "$DO_USR$DO_PWD" || echo $2)
    case "$1" in
        "start" | "restart" )
            $FUNCNAME status && $FUNCNAME stop && sleep 1
            scutil --nc start "$vpn_service" --secret $vpn_secret
            ;;
        "stop" )
            scutil --nc stop "$vpn_service"
            ;;
        "alive" )
            local ip=$(scutil --nc status "VPN GFW" | grep "ServerAddress" | awk '{print $3}')
            local msg=$([[ -z "$ip" ]] && echo "VPN" || echo "VPN[$ip]")
            $FUNCNAME status; _kits_check "$msg"
            ;;
        "keep-alive" )
            $FUNCNAME status || $FUNCNAME start
            ;;
        "status" )
            local status=$(scutil --nc status "$vpn_service" | head -n 1)
            [[ "$status" == "Connected" ]] && return 0 || return 1
            ;;
        # "test" )
        #     # 勿用google
        #     ret=$(curl -s -m 5 http://ipv4.wtfismyip.com/text)
        #     _kits_check "VPN[$ret]"
        #     ;;
        * )
            echo "ERROR. Usage: <start|stop|restart|alive|test>"
            ;;
    esac
}

# kits_vpn_connect() {
#     local vpn_service="VPN GFW"
#     /usr/bin/env osascript <<-EOF
# tell application "System Events"
#     tell current location of network preferences
#         set VPN to service "$vpn_service"
#         if exists VPN then connect VPN
#         repeat while (current configuration of VPN is not connected)
#             delay 1
#         end repeat
#     end tell
# end tell
# EOF
# }

# kits_vpn_disconnect() {
#     local vpn_service="VPN GFW"
#     /usr/bin/env osascript <<-EOF
# tell application "System Events"
#     tell current location of network preferences
#         set VPN to service "$vpn_service"
#         if exists VPN then disconnect VPN
#     end tell
# end tell
# return
# EOF
# }

# kits_vpn_status() {
#     local vpn_service="VPN GFW"
# tell application "System Events"
#  tell current location of network preferences
#   set VPNservice to service "VPN (PPTP)"
#   set isConnected to connected of current configuration of VPNservice
#   if isConnected then disconnect VPNservice
#  end tell
# end tell
# }