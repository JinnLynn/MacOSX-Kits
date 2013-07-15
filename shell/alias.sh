
alias ll="ls -lGh"
alias la="ls -lAGh"
alias cd-="cd - >/dev/null"

alias reload!="[[ -f ~/.bashrc ]] && . ~/.bashrc"
alias alias.find="kits_alias_find"

# SSH相关
# SSH秘钥 SOCK等重置
alias ssh.reset="kits_ssh_reset"
# SSH快速连接
alias ssh.home="ssh $JHOST"
alias ssh.home.root="ssh root@$JHOST"
alias ssh.home.scm="ssh scm@$JHOST"
alias ssh.work="ssh jinnlynn@172.16.5.14"
alias ssh.work.scm="ssh scm@172.16.5.14"
alias ssh.github="ssh -T git@github.com"
alias ssh.ubuntu="ssh jinnlynn@10.211.55.14"
alias ssh.aws="ssh $JEC2USR@$JEC2SERVER"
alias ssh.rpi="ssh pi@$JRPI"
alias ssh.corp="ssh root@$JCORP"
# citypuzzle.org
alias ssh.cp="ssh adminvip@$JCP_HOST"

# SOCKS 代理
alias proxy.start="kits_ssh_proxy start"
alias proxy.stop="kits_ssh_proxy stop"
alias proxy.alive="kits_ssh_proxy alive"
alias proxy.watch="kits_ssh_proxy watch"

# 改变路径
alias to.kits="cd $KITS && pwd"
alias to.shell="cd $KITS/shell && pwd"
alias to.desktop="cd ~/Desktop && pwd"
alias to.scms="cd ~/Developer/SCMs && pwd"
alias to.dev="cd ~/Developer && pwd"
alias to.jeeker="cd ~/Developer/Web/Jeeker && pwd"
alias to.gude="cd ~/Developer/Misc/Gude && pwd"

# 前往当前Finder某个窗口所在目录
alias to.finder="kits_finder_to"

# 在Finder中打开
alias tof="open ."
alias tof.kits="open $KITS"
alias tof.shell="open $KITS/shell"
alias tof.desktop="open ~/Desktop"
alias tof.scms="open ~/Developer/SCMs"
alias tof.dev="open ~/Developer"
alias tof.jeeker="cd ~/Developer/Web/Jeeker"

# 家
# 本地端口转发
alias home.lpf="kits_home_local_port_forward open"
alias home.lpf.close="kits_home_local_port_forward close"
# xiaolu VNC
alias home.vnc="home.lpf 55010:10.95.27.4:5900 && open vnc://localhost:55010"
alias home.vnc.close="home.lpf.close 55010"
# 路由器管理
alias home.router="home.lpf 55020:10.95.27.10:80 && open http://localhost:55020"
alias home.router.close="home.lpf.close 55020"
# NAS share
alias home.nas.share="home.lpf 55030:10.95.27.1:548 && open afp://localhost:55030"
alias home.nas.share.close="home.lpf.close 55030"

# 备份
alias kits.backup="$KITS/extra/backup/backup.py"

# 使用gfwlist生成自动代理配置文件
alias pac.gen="kits_pac_gen"
alias pac.update="pac.gen; corp.update"

# 使用`预览`浏览man内容
alias man.p="kits_man -p"
# 使用`more`浏览man内容
alias man.m="kits_man -m"
# 使用`dash`浏览man内容
alias man.d="kits_man -d"

# 锁定电脑
alias kits.lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# 同步
# kits.sync SOURCE TARGET
alias kits.sync="rsync -avh --force --delete --ignore-errors --delete-excluded --exclude-from='$KITS/cfg/sync-exclude.lst'"
alias kits.sync.all="rsync -avh --force --delete --ignore-errors"
# 同步到web服务器 不同步文件所有者及其所在用户组 包含链接所指向内容
alias kits.sync.to.server="rsync -rLptDhv --stats --force --delete --ignore-errors --progress --exclude=.git/ --exclude-from='$KITS/cfg/sync-exclude.lst'"
# 同步到Windows 不同步权限和设备文件
alias kits.sync.to.win="rsync -rLthv --stats --force --delete --ignore-errors --progress --exclude=.git/ --exclude-from='$KITS/cfg/sync-exclude.lst'"

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
alias kits.itunes="$KITS/shell/extra/itunes.sh"

alias itunes.lyric="$KITS/shell/extra/itunes.sh lyric"
alias itunes.rate="$KITS/shell/extra/itunes.sh rate"
alias itunes.info="$KITS/shell/extra/itunes.sh info"

# iPhone同步与弹出
alias iphone.sync="$KITS/shell/extra/itunes.sh sync"
alias iphone.eject="$KITS/shell/extra/itunes.sh eject"

# MAMP控制
alias mamp.start="kits_mamp start"
alias mamp.stop="kits_mamp stop"
alias mamp.restart="kits_mamp restart"
alias mamp.reload="kits_mamp reload"
alias mamp.alive="kits_mamp alive"

# 隐藏文件的显示控制
alias finder.hidden.show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias finder.hidden.hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# 桌面图标隐藏
alias desktop.hide="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias desktop.show="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# git新建版本库
# <REPONAME>
alias git.nr="kits_git_new_repo"
alias git.nsr="kits_git_new_server_repo"

alias git.scms.pull="kits_pull_all_scms"

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

# squid 控制
alias squid.start="kits_squid start"
alias squid.stop="kits_squid stop"
alias squid.restart="kits_squid restart"
alias squid.alive="kits_squid alive"

alias notify="$KITS/bin/terminal-notifier.app/Contents/MacOS/terminal-notifier"

# Gude
alias gd.env="pve.on gude"
alias gd.install="gd.env && python setup.py install && cd -"
alias gd="gude"
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

# python 虚拟环境
alias pve.name="[[ -d \"\$VIRTUAL_ENV\" ]] && basename \$VIRTUAL_ENV || echo \"no VIRTUAL_ENV\""
alias pve.ls="lsvirtualenv"
alias pve.mk="mkvirtualenv"
alias pve.mk.tmp="mktmpenv"
alias pve.cp="cpvirtualenv"
alias pve.rm="rmvirtualenv"
alias pve.lssp="lssitepackages"
alias pve.setpath="setvirtualenvproject"
alias pve.on="workon"
alias pve.quit="deactivate"

# =========================================================
# NAS
alias nas.kits.update="kits.sync $NASKITS/ root@$JHOST:/volume1/homes/JinnLynn/.kits"
alias nas.ip="ssh.home.root 'curl -s http://ip.3322.net'"

# Download Station
alias nas.ds="$KITS/python/ds"
alias nas.ds.create="nas.ds create"
alias nas.ds.emule="nas.ds emule"
alias nas.ds.clean="nas.ds clean"

alias nas.ip.ddns="dig +short $JHOST_DDNS1; dig +short $JHOST_DDNS2; dig +short $JHOST_DDNS3"
alias nas.ip.host="dig +short $JHOST"


# =========================================================
# RPi
alias rpi.update="kits.sync.to.server ~/Developer/Web/server.rpi/ pi@$JRPI:/data/"
alias rpi.vnc="open vnc://$JRPI"


# ========================================================
# corp server
alias corp.update="kits.sync.to.server $JCORP_DATA root@$JCORP:/data/"

# ========================================================
# jeeker server (aws)
alias aws.update="kits.sync.to.server ~/Developer/Web/server.jeeker/ ubuntu@$JEC2SERVER:/data/"

#
alias iis.update="kits.sync.to.win ~/Developer/Web/sites/citypuzzle.org/ /Volumes/C/inetpub/wwwroot/"