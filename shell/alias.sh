
alias ll="ls -lGh"
alias la="ls -lAGh"
alias cd-="cd - >/dev/null"

alias reload!="[[ -f ~/.bashrc ]] && source ~/.bashrc"

# SSH相关
# SSH秘钥 SOCK等重置
alias ssh.reset="$KITS/shell/ssh.sh reset"
# SSH快速连接
alias ssh.home="ssh $JHOST"
alias ssh.home.root="ssh root@$JHOST"
alias ssh.home.scm="ssh scm@$JHOST"
alias ssh.work="ssh jinnlynn@172.16.5.14"
alias ssh.work.scm="ssh scm@172.16.5.14"
alias ssh.github="ssh -T git@github.com"
alias ssh.ubuntu="ssh jinnlynn@10.211.55.14"
alias ssh.aws="ssh -i $JEC2KEY $JEC2USR@$JEC2SERVER"
alias ssh.rpi="ssh pi@$JRPI"

# 改变路径
alias to.kits="cd $KITS && pwd"
alias to.shell="cd $KITS/shell && pwd"
alias to.desktop="cd ~/Desktop && pwd"
alias to.scms="cd ~/Developer/SCMs && pwd"
alias to.dev="cd ~/Developer && pwd"
alias to.jeeker="cd ~/Developer/Web/Jeeker && pwd"

# 前往当前Finder某个窗口所在目录
alias to.finder="source $KITS/shell/filesystem.sh finder where"

# 在Finder中打开
alias tof.kits="open $KITS"
alias tof.shell="open $KITS/shell"
alias tof.desktop="open ~/Desktop"
alias tof.scms="open ~/Developer/SCMs"
alias tof.dev="open ~/Developer"
alias tof.jeeker="cd ~/Developer/Web/Jeeker"

# KITS
alias kits="kits.sh"

# 备份
alias kits.backup="kits backup"

# 使用gfwlist生成自动代理配置文件
alias kits.pac.gen="kits genpac && cp $KITS/extra/genpac/AutoProxy.pac $JPACGIST/pac.js && cp $JPACGIST/pac.js $JJEEKER_DEPLOY/assets/"
alias kits.pac.pub="cd $JPACGIST && kits.pac.gen && git commit -a -m 'updated' && git push && cd-"
# 使用`预览`打开man内容
# <APP_NAME>
alias kits.manp="kits manp"

# 锁定电脑
alias kits.lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# 同步
# kits.sync SOURCE TARGET
alias kits.sync="rsync -avh --force --delete --ignore-errors --delete-excluded --exclude-from='$KITS/cfg/sync-exclude.lst'"
alias kits.sync.all="rsync -avh --force --delete --ignore-errors"

# 网址测试
alias kits.url="curl -o /dev/null -s -w '\nCode\tConn\tTran\tTotal\tSize\tURL\n%{http_code}\t%{time_connect}\t%{time_starttransfer}\t%{time_total}\t%{size_download}\t%{url_effective}\n\n'"
alias kits.url.nas="kits.url $JURL_NAS"
alias kits.url.pac="kits.url $JURL_PAC"

# 查看IP
alias kits.ip="curl -s http://ip.3322.net"

# VNC
alias kits.vnc="open /System/Library/CoreServices/Screen\ Sharing.app"

# itunes
# <lyric|rate> [RATE_NUM]
# lyric = 获取当前播放音乐的歌词 rate = 给当前播放的歌曲评级 info = 当前信息
# RATE_NUM 如果$1=rate才有效 1~5
alias kits.itunes="$KITS/shell/itunes.sh"

alias itunes.lyric="$KITS/shell/itunes.sh lyric"
alias itunes.rate="$KITS/shell/itunes.sh rate"
alias itunes.info="$KITS/shell/itunes.sh info"

# iPhone同步与弹出
alias iphone.sync="$KITS/shell/itunes.sh sync"
alias iphone.eject="$KITS/shell/itunes.sh eject"

# MAMP控制
alias mamp.start="$KITS/shell/mamp.sh start"
alias mamp.stop="$KITS/shell/mamp.sh stop"
alias mamp.restart="$KITS/shell/mamp.sh restart"
alias mamp.isrunning="$KITS/shell/mamp.sh isrunning"

# 隐藏文件的显示控制
alias finder.hidden.show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias finder.hidden.hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# 桌面图标隐藏
alias desktop.hide="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias desktop.show="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# 在Finder中打开文件夹
# [FOLDER_OR_FILE_NAME] 默认当前工作目录
alias finder.open="$KITS/shell/filesystem.sh finder open"

# git新建版本库
# <REPONAME>
alias git.nr="$KITS/shell/git.sh newrepo"
alias git.nsr="$KITS/shell/git.sh newserverrepo"

alias git.scms.pull="$KITS/shell/git.sh pullallscms"

# WIFI控制
# 启用与禁用 <on|off|reset>
alias wifi.power="$KITS/shell/wifi.sh power"
alias wifi.on="wifi.power on"
alias wifi.off="wifi.power off"
alias wifi.reset="wifi.power reset"
# 位置配置 <auto|LOCATION_NAME>
alias wifi.loc="$KITS/shell/wifi.sh location"
alias wifi.loc.auto="wifi.loc auto"
alias wifi.loc.ascfj="wifi.loc ASCFJ"
# 代理 <all|auto|off>
alias wifi.proxy="$KITS/shell/wifi.sh proxy"
# IP <manual|dhcp> [<IP> <SUBNET> <DNS>]
# 当$1 = manual时 后面的参数必须
alias wifi.ip="$KITS/shell/wifi.sh ip"

# squid 控制
alias squid.start="$KITS/shell/squid.sh start"
alias squid.stop="$KITS/shell/squid.sh stop"
alias squid.restart="$KITS/shell/squid.sh restart"
alias squid.isrunning="$KITS/shell/squid.sh isrunning"

alias notify="$KITS/bin/terminal-notifier.app/Contents/MacOS/terminal-notifier"

# Gude
alias gd="~/Developer/Misc/Gude/gd"
alias gd.init="gd init"
alias gd.add="gd add"
alias gd.build="gd build"
alias gd.publish="gd publish"
alias gd.serve="gd serve"
alias gd.local="gd build -lp"
alias gd.remote="gd publish -b"

# 清理Xcode临时文件
alias clean.xcode="rm -rf ~/Library/Developer/Xcode/DerivedData"
# 清空DNS缓存
alias clean.dns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
# 清除右键菜单Open With重复项
alias clean.openwith="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain system -domain user; killall Finder"


# =========================================================
# NAS

alias nas.kits.update="kits.sync $NASKITS/ root@$JHOST:/root/nas-kits"

alias nas.ip="ssh.home.root 'curl -s http://ip.3322.net'"

# Download Station
alias nas.ds="$KITS/python/ds"
alias nas.ds.create="nas.ds create"
alias nas.ds.emule="nas.ds emule"
alias nas.ds.clean="nas.ds clean"


# =========================================================
# RPi

alias rpi.kits.update="kits.sync $RPIKITS/ pi@$JRPI:/home/pi/rpi-kits"
alias rpi.vnc="open vnc://$JRPI"