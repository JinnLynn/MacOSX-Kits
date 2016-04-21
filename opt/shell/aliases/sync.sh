# 同步相关

# kits.sync SOURCE TARGET
alias kits.sync="rsync -avh --force --delete --ignore-errors --progress --stats --delete-excluded --exclude-from='$KITS/etc/rsync-exclude.lst'"
alias kits.sync.all="rsync -avh --force --delete --ignore-errors"
# 同步到web服务器 不同步文件所有者及其所在用户组 包含链接所指向内容
alias kits.sync.to.server="rsync -rLptDhv --stats --force --delete --ignore-errors --progress --exclude=.git/ --exclude-from='$KITS/etc/rsync-exclude.lst'"
# 同步到Windows 不同步权限和设备文件
alias kits.sync.to.win="rsync -rLthv --stats --force --delete --ignore-errors --progress --exclude=.git/ --exclude-from='$KITS/etc/rsync-exclude.lst'"

# VM Ubuntu Server
alias vmus.kits.update="kits.sync -e 'ssh' $VMUS_KITS/ $VMUS_SRV:/data/kits/"
# RPi
alias rpi.update="kits.sync.to.server ~/Developer/Web/server.rpi/ pi@$JRPI:/data/"
alias rpi.vnc="open vnc://$JRPI"
# jeeker server
alias jeeker.update="kits.sync.to.server ~/Developer/Web/server.jeeker/ $JJEEKER_SRV:/data/"
alias cp.update="kits.sync.to.win --exclude=_dev/*/*.rar --exclude=_dev/node_modules/  --exclude=farm/ --exclude=_dev/test/100mb.bin --exclude=config-dev.php ~/Developer/Web/sites/citypuzzle.org/ $JCP_SRV:/cygdrive/d/www/citypuzzle.org/"
alias iis.update="kits.sync.to.win ~/Developer/Web/sites/citypuzzle.org/ /Volumes/C/inetpub/wwwroot/"
alias dd.update="cd ~/Developer/Web/sites/ddbabybook.com/_dev; grunt shell:sync_remote"