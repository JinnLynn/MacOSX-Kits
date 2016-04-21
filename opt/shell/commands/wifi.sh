# WIFI相关控制

kits_wifi() {
    local wifins="Wi-Fi"
    # WIFI device name
    local wifidn="en1"
    case "$1" in
        # WIFI的电源控制
        "power" )
            case "$2" in
                "off"|"on" )
                    networksetup -setairportpower "$wifidn" $2
                ;;
                "reset" )
                    $0 power off
                    sleep 1
                    $0 power on
                ;;
                * )
                    echo "ERROR. Usage: power <off|on|reset>"
                ;;
            esac
        ;;
        # 地点配置
        "location"|"loc" )
            local loc=$2
            if [[ "$loc" = 'auto' || "$loc" = '' ]]; then loc="Automatic"; fi
            scselect "$loc" >/dev/null
        ;;
        "proxy" )
            case "$2" in
                "all" )
                    networksetup -setsocksfirewallproxy "$wifins" "127.0.0.1" "$JPROXY_SOCKS_PORT" off
                    networksetup -setsocksfirewallproxystate "$wifins" on
                    networksetup -setautoproxystate "$wifins" off
                    ;;
                "auto" )
                    networksetup -setsocksfirewallproxystate "$wifins" off
                    networksetup -setautoproxyurl "$wifins" "$JPAC_URL"
                    ;;
                "off" )
                    networksetup -setsocksfirewallproxystate "$wifins" off
                    networksetup -setautoproxystate "$wifins" off
                    ;;
                * )
                    echo "ERROR. Usage: proxy <all|auto|off>"
                ;;
            esac
        ;;
        "ip" )
            case "$2" in
                "manual" )
                    if [[ -z "$3" || -z "$4" || -z "$5" ]]; then
                        echo "ERROR. Missing args."
                        exit
                    fi
                    networksetup -setmanual "$wifins" "$3" "$4" "$5"
                    ;;
                "dhcp" )
                    networksetup -setdhcp "$wifins"
                    ;;
                * )
                    echo "ERROR. Usage: ip <manual|dhcp> [<IP SUBNET DNS>]"
                ;;
            esac
        ;;
        "info" )
            #echo "Location: $(networksetup -getcurrentlocation)"
            #networksetup -getinfo "$wifins"
            networksetup -getautoproxyurl "$wifins"
        ;;
        * )
            echo "ERROR. Usage: <power|location|loc|proxy|ip> [ARGS]"
        ;;
    esac
}