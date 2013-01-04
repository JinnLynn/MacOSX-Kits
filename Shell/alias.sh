
alias ll="ls -lGh"
alias la="ls -lAGh"

# Sublime Text 2的命令行模式
alias subl="/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl"

# SSH相关
# SSH秘钥 SOCK等重置
alias ssh.reset="$KITSSHELL/ssh.sh reset"
# SSH快速连接
alias ssh.home="ssh $JHOST"
alias ssh.homeroot="ssh root@$JHOST"
alias ssh.scm="ssh scm@$JHOST"
alias ssh.work="ssh jinnlynn@172.16.5.14"
alias ssh.workscm="ssh scm@172.16.5.14"
alias ssh.github="ssh -T git@github.com"
alias ssh.ubuntu="ssh jinnlynn@10.211.55.14"

# 改变路径
alias to.kits="cd $KITS; pwd"
alias to.shell="cd $KITSSHELL; pwd"
alias to.desktop="cd ~/Desktop; pwd"
alias to.scms="cd ~/Developer/SCMs; pwd"
alias to.dev="cd ~/Developer; pwd"
alias to.jeeker="cd ~/Developer/Web/Jeeker; pwd"
alias to.wendy="cd ~/Developer/Web/Host/Wendy.jeeker.net; pwd"
alias to.afvisual="cd ~/Developer/Web/Host/Afvisual.com; pwd"

# 前往当前Finder某个窗口所在目录
alias to.finder="source $KITSSHELL/filesystem.sh finder where"

# 在Finder中打开
alias tof.kits="to.kits; finder.open"
alias tof.shell="to.shell; finder.open"
alias tof.desktop="to.desktop; finder.open"
alias tof.scms="to.scms; finder.open"
alias tof.dev="to.dev; finder.open"
alias tof.jeeker="to.jeeker; finder.open"
alias tof.wendy="to.wendy; finder.open"
alias tof.afvisual="to.afvisual; finder.open"

# KITS
alias kits="kits.sh"

# 备份
alias kits.backup="kits backup"
# 使用gfwlist生成自动代理配置文件
alias kits.genpac="kits genpac && scp $KITS/GenPAC/AutoProxy.pac root@$JHOME:/volume1/web/assets/pac.js && ssh root@$JHOME 'chmod 644 /volume1/web/assets/pac.js'"
# 使用`预览`打开man内容
# <APP_NAME>
alias kits.manp="kits manp"

# 锁定电脑
alias kits.lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# 同步
# kits.sync SOURCE TARGET
alias kits.sync="rsync -av --force --delete --ignore-errors --delete-excluded --exclude-from='$KITSSHELL/cfg/sync_exclude.lst'"
alias kits.sync.all="rsync -av --force --delete --ignore-errors"

# 清除右键菜单Open With重复项
alias kits.clear.openwith="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain system -domain user; killall Finder"

# itunes
# <lyric|rate> [RATE_NUM]
# lyric = 获取当前播放音乐的歌词 rate = 给当前播放的歌曲评级 info = 当前信息
# RATE_NUM 如果$1=rate才有效 1~5
alias kits.itunes="$KITSSHELL/itunes.sh"

alias itunes.lyric="$KITSSHELL/itunes.sh lyric"
alias itunes.rate="$KITSSHELL/itunes.sh rate"
alias itunes.info="$KITSSHELL/itunes.sh info"

# iPhone同步与弹出
alias iphone.sync="$KITSSHELL/itunes.sh sync"
alias iphone.eject="$KITSSHELL/itunes.sh eject"

# MAMP控制
alias mamp.start="$KITSSHELL/mamp.sh start"
alias mamp.stop="$KITSSHELL/mamp.sh stop"
alias mamp.restart="$KITSSHELL/mamp.sh restart"
alias mamp.isrunning="$KITSSHELL/mamp.sh isrunning"

# 隐藏文件的显示控制
# [show|hide] 默认hide
alias finder.hidden="$KITSSHELL/filesystem.sh hiddenfiles"

# 在Finder中打开文件夹
# [FOLDER_OR_FILE_NAME] 默认当前工作目录
alias finder.open="$KITSSHELL/filesystem.sh finder open"

# git新建版本库
# <REPONAME>
alias git.nr="$KITSSHELL/git.sh newrepo"
alias git.nsr="$KITSSHELL/git.sh newserverrepo"

alias git.scms.pull="$KITSSHELL/git.sh pullallscms"

# WIFI控制
# 启用与禁用 <on|off|reset>
alias wifi.power="$KITSSHELL/wifi.sh power"
alias wifi.on="wifi.power on"
alias wifi.off="wifi.power off"
alias wifi.reset="wifi.power reset"
# 位置配置 <auto|LOCATION_NAME>
alias wifi.loc="$KITSSHELL/wifi.sh location"
alias wifi.loc.auto="wifi.loc auto"
alias wifi.loc.ascfj="wifi.loc ASCFJ"
# 代理 <all|auto|off>
alias wifi.proxy="$KITSSHELL/wifi.sh proxy"
# IP <manual|dhcp> [<IP> <SUBNET> <DNS>]
# 当$1 = manual时 后面的参数必须
alias wifi.ip="$KITSSHELL/wifi.sh ip"

# squid 控制
alias squid.start="$KITSSHELL/squid.sh start"
alias squid.stop="$KITSSHELL/squid.sh stop"
alias squid.restart="$KITSSHELL/squid.sh restart"
alias squid.isrunning="$KITSSHELL/squid.sh isrunning"

alias notify="$KITS/bin/terminal-notifier.app/Contents/MacOS/terminal-notifier"

# Gude
alias gd="~/Developer/Misc/Gude/gd"
alias gd.init="gd init"
alias gd.add="gd add"
alias gd.build="gd build"
alias gd.publish="gd publish"
alias gd.serve="gd serve"
alias gd.repub="gd.build; gd.publish"

# 清理Xcode临时文件
alias clean.xcode="rm -rf ~/Library/Developer/Xcode/DerivedData"
# 清空DNS缓存
alias clean.dns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
# 清除右键菜单Open With重复项
alias clean.openwith="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain system -domain user; killall Finder"