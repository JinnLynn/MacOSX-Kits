# 是否显示隐藏的文件
function show_hidden_files() {
    defaults write com.apple.Finder AppleShowAllFiles $1
    osascript -e 'tell application "Finder" to quit'
    sleep 1
    osascript -e 'tell application "Finder" to activate'
}

case $1 in
    'hiddenfiles' )     #隐藏文件的显示与隐藏
        if [ "$2" = 'show' ]; then
                show_hidden_files YES
        elif [ "$2" = 'hide' ]; then
                show_hidden_files NO
        fi
        ;;
    * )
        echo "kits: '$1' is not a kits command. See 'kits usage'."
        ;;
esac
