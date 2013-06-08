# MAMP相关控制

function kits_mamp() {
    mamp_path="/Applications/MAMP"
    pushd $mamp_path/bin/ > /dev/null
    case "$1" in
        "start" )
            ./start.sh
            ;;
        "stop" )
            ./stop.sh
            ;;
        "restart" )
            ./stop.sh
            sleep 1
            ./start.sh
            ;;
        "reload" )
            $mamp_path/Library/bin/apachectl graceful
            ;;
        "alive" )
            [[ $(ps aux | grep $mamp_path | grep -c "httpd") -gt 0 ]]; _kits_check "Apache"
            [[ $(ps aux | grep $mamp_path | grep -c "mysqld") -gt 0 ]]; _kits_check "MySQL"
            ;;
        * )
            echo "ERROR. Usage: <start|stop|restart|alive>"
            ;;
    esac
    popd > /dev/null
}
