#!/bin/bash

##
# WIFI相关控制
##

# WIFI networkservice
wifins="Wi-Fi"
# WIFI device name
wifidn="en1"
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
                echo "ERROR. Usage: wifi.sh power <off|on|reset>"
            ;;
        esac
    ;;
    # 地点配置
    "location"|"loc" )
        loc=$2
        if [[ "$loc" = 'auto' || "$loc" = '' ]]; then loc="Automatic"; fi
        networksetup -switchtolocation "$loc" >/dev/null
    ;;
    "proxy" )
        case "$2" in
            "all" )
                networksetup -setsocksfirewallproxy "$wifins" "$JPROXYSOCKSHOST" "$JPROXYSOCKSPORT" off
                networksetup -setsocksfirewallproxystate "$wifins" on
                networksetup -setautoproxystate "$wifins" off
                ;;
            "auto" )
                networksetup -setsocksfirewallproxystate "$wifins" off
                networksetup -setautoproxyurl "$wifins" "$JPACURL"
                ;;
            "off" )
                networksetup -setsocksfirewallproxystate "$wifins" off
                networksetup -setautoproxystate "$wifins" off
                ;;
            * )
                echo "ERROR. Usage: wifi.sh proxy <all|auto|off>"
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
                echo "ERROR. Usage: wifi.sh ip <manual|dhcp> [<IP SUBNET DNS>]"
            ;;
        esac
    ;;
    "info" )
        #echo "Location: $(networksetup -getcurrentlocation)"
        #networksetup -getinfo "$wifins"
        networksetup -getautoproxyurl "$wifins"
    ;;
    * )
        echo "ERROR. Usage: wifi.sh <power|location|loc|proxy|ip> [ARGS]"
    ;;
esac