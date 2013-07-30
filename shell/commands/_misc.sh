# 使用Preview | more | dash打开man内容
function kits_man() {
    error="ERROR. Usage: kits_man [-p|-m|-d] COMMAND_NAME"
    [[ -z "$2" ]] && echo "$error" && return 1
    case $1 in
        "-p" )
            man -t $2 | open -f -a /Applications/Preview.app
        ;;
        "-m" )
            man $2 | more
        ;;
        "-d" )
            open "dash://man:$2"
        ;;
        * )
            echo $error
        ;;
    esac
}

# 别名查找
function kits_alias_find() {
   alias | awk -F '=' {'print $1'} | awk {'print $2'} | grep "$1"
}