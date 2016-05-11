# NAS相关

# 不能使用kits.sync(即不使用参数--delete-excluded) 避免var目录被删除
alias nas.kits.update="rsync -avh --force --delete --ignore-errors --progress --stats --exclude-from='$KITS/etc/rsync-exclude.lst' --protocol=30 --rsync-path /usr/bin/rsync -e 'ssh -p $JHOME_SSH_PORT -i $JKEY' --exclude='/var' $NASKITS/ root@$JHOME:/volume1/cellar/kits/"
alias nas.ip="ssh.home 'curl -s http://ip.3322.net'"
alias nas.ip.host="dig +short $JHOST"

# Download Station
alias nas.ds="$KITS/python/ds"
alias nas.ds.create="nas.ds create"
alias nas.ds.emule="nas.ds emule"
alias nas.ds.clean="nas.ds clean"

# 迅雷远程 下载
alias nas.tdd.start="ssh.home \"bash -ic 'tdd.start'\""
alias nas.tdd.stop="ssh.home \"bash -ic 'tdd.stop'\""
alias nas.tdd.restart="ssh.home \"bash -ic 'tdd.restart'\""
alias nas.tdd.alive="ssh.home \"bash -ic 'tdd.alive'\""
alias nas.tdd.keep-alive="ssh.home \"bash -ic 'tdd.keep-alive'\""

alias nas.tdd.tmp="ssh.home \"cd /volume2/Temp/Downloads && chown -R JinnLynn * && chmod -R 644 *\""