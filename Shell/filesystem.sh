# 显示隐藏的文件
function showhiddenfiles() {
  defaults write com.apple.Finder AppleShowAllFiles YES
  osascript -e 'tell application "Finder" to quit'
  sleep 1
  osascript -e 'tell application "Finder" to activate'
}

# 隐藏隐藏的文件
function hidehiddenfiles() {
  defaults write com.apple.Finder AppleShowAllFiles NO
  osascript -e 'tell application "Finder" to quit'
  sleep 1
  osascript -e 'tell application "Finder" to activate'
}

case $1 in
    'hiddenfiles' )     #隐藏文件的显示与隐藏
        if [ "$2" = 'show' ]; then
            showhiddenfiles
        elif [ "$2" = 'hide' ]; then
            hidehiddenfiles
        fi
        ;;
    * )
        echo "kits: '$1' is not a kits command. See 'kits usage'."
        ;;
esac
