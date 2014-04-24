
alias ll="ls -lGh"
alias la="ls -lAGh"
alias cd-="cd - >/dev/null"

alias reload!="exec $SHELL" # "[[ -f ~/.bashrc ]] && . ~/.bashrc"
alias kits.af="kits_alias_find"

# SSH相关
# SSH秘钥 SOCK等重置
alias ssh.reset="kits_ssh_reset"
# SSH端口转发
alias ssh.lpf="kits_ssh_port_forward local"
alias ssh.rpf="kits_ssh_port_forward remote"
alias ssh.dpf="kits_ssh_port_forward dynamic"
alias ssh.cpf="kits_ssh_port_forward close"
# SSH快速连接
alias ssh.home="ssh $JHOST"
alias ssh.home.root="ssh root@$JHOST"
alias ssh.home.scm="ssh scm@$JHOST"
alias ssh.work="ssh jinnlynn@172.16.5.14"
alias ssh.work.scm="ssh scm@172.16.5.14"
alias ssh.github="ssh -T git@github.com"
alias ssh.ubuntu="ssh jinnlynn@10.211.55.14"
alias ssh.jeeker="ssh $JJEEKER_SRV"
alias ssh.rpi="ssh pi@$JRPI"
alias ssh.corp="ssh $JCORP_SRV"
# citypuzzle.org
alias ssh.cp="ssh $JCP_SRV"

# 代理相关
# SSH服务器
alias proxy.start="kits_ssh_proxy start; privoxy.start"
alias proxy.start.global="kits_ssh_proxy start global; privoxy.start"
alias proxy.stop="kits_ssh_proxy stop; privoxy.stop"
alias proxy.watch="kits_ssh_proxy watch"
alias proxy.alive="kits_proxy_alive"
alias proxy.pac="kits_pac_update"
alias proxy.test="ssh -v $JPROXY_SRV \"exit\""
# 使用代理下载文件
alias proxy.dl="cd ~/Downloads && curl -O# --socks5 localhost:$JPROXY_SOCKS_PORT"

# 家
alias proxy.home.start="kits_ssh_proxy start $JPROXY_HOME_SOCKS_PORT $JHOME"
alias proxy.home.stop="kits_ssh_proxy stop $JPROXY_HOME_SOCKS_PORT"
alias proxy.home.alive="kits_ssh_proxy alive $JPROXY_HOME_SOCKS_PORT"
alias proxy.home.watch="kits_ssh_proxy watch $JPROXY_HOME_SOCKS_PORT"
alias proxy.home.test="ssh -v $JHOME \"exit\""

# privoxy
alias privoxy.start="kits_privoxy start"
alias privoxy.stop="kits_privoxy stop"
# squid
alias squid.start="kits_squid start"
alias squid.stop="kits_squid stop"
alias squid.restart="kits_squid restart"
alias squid.alive="kits_squid alive"

# 改变路径
alias to.kits="cd $KITS && pwd"
alias to.shell="cd $KITS/shell && pwd"
alias to.desktop="cd ~/Desktop && pwd"
alias to.scms="cd ~/Developer/SCMs && pwd"
alias to.dev="cd ~/Developer && pwd"
alias to.jeeker="cd ~/Developer/Web/Jeeker && pwd"
alias to.gude="cd ~/Developer/Misc/Gude && pwd"
alias to.dp="cd /Volumes/ExtraHD/CloudServices/Dropbox && pwd"

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
# xiaolu VNC
alias home.vnc="ssh.lpf 60010:10.95.27.3:5900 && open vnc://localhost:60010"
alias home.vnc.off="ssh.cpf 60010"
# 路由器管理
alias home.router="ssh.lpf 60020:10.95.27.10:80 && open http://localhost:60020"
alias home.router.off="ssh.cpf 60020"
# NAS Web Admin
alias home.nas="ssh.lpf 60030:10.95.27.1:5051 && open https://localhost:60030"
alias home.nas.off="ssh.cpf 60030"
# NAS share
alias home.nas.share="ssh.lpf 60040:10.95.27.1:548 && open afp://localhost:60040"
alias home.nas.share.off="ssh.cpf 60040"

# mldonkey
alias mld.web="ssh.lpf 60100:127.0.0.1:4080 $JCORP_SRV && open http://localhost:60100"
alias mld.web.off="ssh.cpf 60100"
alias mld.files="ssh $JCORP_SRV \"cd /var/lib/mldonkey/incoming/ && df -h . && pwd && ls -AlhR\""

# 备份
alias kits.backup="$KITS/extra/backup/backup.py"
alias kits.backup.quick="kits.backup --no-exact-progress"

# 使用gfwlist生成自动代理配置文件
alias pac.gen="kits_pac_gen"
alias pac.update="kits_pac_update"
alias pac.effect="kits_pac_effective_immediately"

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
alias kits.sync="rsync -avh --force --delete --ignore-errors --delete-excluded --exclude-from='$KITS/config/sync-exclude.lst'"
alias kits.sync.all="rsync -avh --force --delete --ignore-errors"
# 同步到web服务器 不同步文件所有者及其所在用户组 包含链接所指向内容
alias kits.sync.to.server="rsync -rLptDhv --stats --force --delete --ignore-errors --progress --exclude=.git/ --exclude-from='$KITS/config/sync-exclude.lst'"
# 同步到Windows 不同步权限和设备文件
alias kits.sync.to.win="rsync -rLthv --stats --force --delete --ignore-errors --progress --exclude=.git/ --exclude-from='$KITS/config/sync-exclude.lst'"

# 网址测试
alias kits.url="curl -o /dev/null -s -w '\nCode\tConn\tTran\tTotal\tSize\tURL\n%{http_code}\t%{time_connect}\t%{time_starttransfer}\t%{time_total}\t%{size_download}\t%{url_effective}\n\n'"
alias kits.url.nas="kits.url $JURL_NAS"
alias kits.url.pac="kits.url $JPAC_URL"

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
# 建立
alias pve.mk="mkvirtualenv"
alias pve.mk.tmp="mktmpenv"
# 建立 基于python3
alias pve3.mk="pve.mk --python=/usr/local/bin/python3"
alias pve3.mk.tmp="pve.mk.tmp --python=/usr/local/bin/python3"
# 启用与退出
alias pve.on="workon"
alias pve.exit="deactivate"
# 名称 列表 目录 拷贝 删除
alias pve.name="[[ -d \"\$VIRTUAL_ENV\" ]] && basename \$VIRTUAL_ENV || echo \"no VIRTUAL_ENV\""
alias pve.ls="lsvirtualenv"
alias pve.ls.sp="lssitepackages"
alias pve.cd="cdvirtualenv"
alias pve.cd.sp="cdsitepackages"
alias pve.cd.proj="cdproject"
alias pve.cp="cpvirtualenv"
alias pve.rm="rmvirtualenv"
# 设置项目目录
alias pve.setpath="setvirtualenvproject"
# 清理 删除安装的模块
alias pve.clean="wipeenv"
# 进入virtual env目录
alias pve.dir="[[ -d \"\$VIRTUAL_ENV\" ]] && (cd \$VIRTUAL_ENV; pwd) || echo \"no VIRTUAL_ENV\""

# Parallels Desktop 虚拟机
alias vm.bc.start="kits_virtual_machine start \"BootCamp\""
alias vm.bc.stop="kits_virtual_machine stop \"BootCamp\""

# screen
alias scr="screen"
alias scr.ls='screen -ls'
alias scr.mk='screen -S'
alias scr.mkd='screen -dmS'
alias scr.cd='screen -dR'

# SSD状态
alias status.ssd="$KITS/python/ssd-status.py"

alias alive="proxy.alive; mamp.alive"

# =========================================================
# NAS
alias nas.kits.update="kits.sync $NASKITS/ root@$JHOST:/volume1/cellar/kits/"
alias nas.ip="ssh.home 'curl -s http://ip.3322.net'"
alias nas.ip.host="dig +short $JHOST"

# Download Station
alias nas.ds="$KITS/python/ds"
alias nas.ds.create="nas.ds create"
alias nas.ds.emule="nas.ds emule"
alias nas.ds.clean="nas.ds clean"


# =========================================================
# RPi
alias rpi.update="kits.sync.to.server ~/Developer/Web/server.rpi/ pi@$JRPI:/data/"
alias rpi.vnc="open vnc://$JRPI"


# ========================================================
# corp server
alias corp.update="kits.sync.to.server --exclude=_dev/ $JCORP_DATA $JCORP_SRV:/data/"

# ========================================================
# jeeker server
alias jeeker.update="kits.sync.to.server ~/Developer/Web/server.jeeker/ $JJEEKER_SRV:/data/"

alias cp.update="kits.sync.to.win --exclude=_dev/*/*.rar --exclude=_dev/node_modules/  --exclude=farm/ --exclude=_dev/test/100mb.bin --exclude=config-dev.php ~/Developer/Web/sites/citypuzzle.org/ $JCP_SRV:/cygdrive/d/www/citypuzzle.org/"
#
alias iis.update="kits.sync.to.win ~/Developer/Web/sites/citypuzzle.org/ /Volumes/C/inetpub/wwwroot/"

alias dd.update="cd ~/Developer/Web/sites/ddbabybook.com/_dev; grunt shell:sync_remote"


alias tmp.lr="kits.sync.to.win --delete-excluded --exclude=node_modules/ ~/Developer/Web/sites/logistics4lr/ ~/Desktop/lr$(date +%Y%m%d)"

alias diablo="open \"/Applications/Diablo III/Diablo III.app\""
alias diablo.tw="open \"/Applications/Diablo III/Diablo III.app\" --args -launch OnlineService.Matchmaking.ServerPool=TW3"
alias diablo.kr="open \"/Applications/Diablo III/Diablo III.app\" --args -launch OnlineService.Matchmaking.ServerPool=Default"