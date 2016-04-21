# 系统功能相关

# 蓝牙
alias bt.on="blueutil on"
alias bt.off="blueutil off"

# 备份
alias kits.backup="$KITS/opt/backup/backup.py | tee $KITS_LOG/bak-$(kits_time -d).log"
alias kits.backup.quick="$KITS/opt/backup/backup.py --no-exact-progress"

# 锁定电脑
alias kits.lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# 隐藏文件的显示控制
alias finder.hidden.show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias finder.hidden.hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# 桌面图标隐藏
alias desktop.hide="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias desktop.show="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# 清理Xcode临时文件
alias clean.xcode="rm -rf ~/Library/Developer/Xcode/DerivedData"
# 清空DNS缓存
alias clean.dns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
# 清除右键菜单Open With重复项
alias clean.openwith="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain system -domain user; killall Finder"

# WIFI控制
# 启用与禁用 <on|off|reset>
alias wifi.power="kits_wifi power"
alias wifi.on="wifi.power on"
alias wifi.off="wifi.power off"
alias wifi.reset="wifi.power reset"
# 位置配置 <auto|LOCATION_NAME>
alias wifi.loc="kits_wifi location"
alias wifi.loc.auto="wifi.loc auto"
alias wifi.loc.ascfj="wifi.loc ASCFJ"
# 代理 <all|auto|off>
alias wifi.proxy="kits_wifi proxy"
# IP <manual|dhcp> [<IP> <SUBNET> <DNS>]
# 当$1 = manual时 后面的参数必须
alias wifi.ip="kits_wifi ip"

alias notify="$KITS/bin/terminal-notifier.app/Contents/MacOS/terminal-notifier"

# SSD状态
alias status.ssd="$KITS/python/ssd-status.py"

# 使用`预览`浏览man内容
alias man.p="kits_man -p"
# 使用`more`浏览man内容
alias man.m="kits_man -m"
# 使用`dash`浏览man内容
alias man.d="kits_man -d"

# 网址测试
# alias kits.url="curl -o /dev/null -s -w '\nCode\tConn\tTran\tTotal\tSize\tURL\n%{http_code}\t%{time_connect}\t%{time_starttransfer}\t%{time_total}\t%{size_download}\t%{url_effective}\n\n'"
alias kits.url="curl -o /dev/null -s -w 'URL:   %{url_effective}\nCode:  %{http_code}\nConn:  %{time_connect}\nTran:  %{time_starttransfer}\nTotal: %{time_total}\nSize:  %{size_download}\nSpeed: %{speed_download}\n'"
alias kits.url.nas="kits.url $JURL_NAS"

# 查看IP
alias kits.ip="curl -s http://ip.3322.net"

# VNC
alias kits.vnc="open /System/Library/CoreServices/Screen\ Sharing.app"

# Parallels Desktop 虚拟机
alias vm.bc.start="kits_virtual_machine start \"BootCamp\""
alias vm.bc.stop="kits_virtual_machine stop \"BootCamp\""

# screen
alias scr="screen"
alias scr.ls='screen -ls'
alias scr.mk='screen -S'
alias scr.mkd='screen -dmS'
alias scr.cd='screen -dR'
