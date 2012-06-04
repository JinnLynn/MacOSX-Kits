
alias ll="ls -h -l"

# Sublime Text 2的命令行模式
alias subl="/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl"

# SSH快速连接
alias ssh.home="ssh $JHOST"
alias ssh.scm="ssh scm@$JHOST"
alias ssh.work="ssh jinnlynn@172.16.5.14"
alias ssh.github="ssh -T git@github.com"

# 改变路径
alias to.kits="cd $KITS; pwd"
alias to.shell="cd $KITSSHELL; pwd"


# KITS
alias kits="kits.sh"

# 备份
alias kits.backup="kits backup"
# 使用gfwlist生成自动代理配置文件
alias kits.genpac="kits genpac"
# 使用`预览`打开man内容
# $1 待查程序名 必须
alias kits.manp="kits manp"

# itunes
# $1 类型 lyric = 获取当前播放音乐的歌词 rate = 给当前播放的歌曲评级
# $2 如果$1=rate才有效 1~5
alias kits.itunes="kits itunes"

# MAMP控制
alias kits.mamp.start="kits mamp start"
alias kits.mamp.stop="kits mamp stop"
alias kits.mamp.restart="kits mamp restart"

# 隐藏文件的显示控制
alias kits.hiddenfiles.show="$KITSSHELL/filesystem.sh hiddenfiles show"
alias kits.hiddenfiles.hide="$KITSSHELL/filesystem.sh hiddenfiles hide"

# SSH秘钥 SOCK等重置
alias kits.ssh.reset="$KITSSHELL/network.sh ssh reset"