alias kits="kits.sh"

alias ll="ls -h -l"

#sublime text 2的命令行模式
alias subl="/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl"

#SSH相关
alias ssh.home="ssh $JHOST"
alias ssh.scm="ssh scm@$JHOST"
alias ssh.work="ssh jinnlynn@172.16.5.14"
alias ssh.github="ssh -T git@github.com"

#路径更改
alias to.kits="cd $KITS; pwd"
alias to.shell="cd $KITSSHELL; pwd"


#KITS

alias kits.backup="kits backup"
alias kits.genpac="kits genpac"

#itunes 需袋参数
# $1 类型 lyric = 获取当前播放音乐的歌词 rate = 给当前播放的歌曲评级
# $2 如果$1=rate才有效 1~5
alias kits.itunes="kits itunes"

#MAMP控制
alias kits.mamp.start="kits mamp start"
alias kits.mamp.stop="kits mamp stop"
alias kits.mamp.restart="kits mamp restart"

#隐藏文件的显示与否
alias kits.hiddenfiles.show="$KITSSHELL/filesystem.sh hiddenfiles show"
alias kits.hiddenfiles.hide="$KITSSHELL/filesystem.sh hiddenfiles hide"