# 即将弃用

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

# diablo3
alias diablo="open \"/Applications/Diablo III/Diablo III.app\" --args -launch"
alias diablo.tw="open \"/Applications/Diablo III/Diablo III.app\" --args -launch OnlineService.Matchmaking.ServerPool=TW3"
alias diablo.kr="open \"/Applications/Diablo III/Diablo III.app\" --args -launch OnlineService.Matchmaking.ServerPool=Default"