# Parallels Desktop虚拟机的控制
kits_virtual_machine() {
    # VM名是否指定
    [[ -z "$2" ]] && echo "VM name missing." && return 127
    
    # VM是否存在
    prlctl list "$2" > /dev/null 2>&1
    [[ ! $? -eq 0 ]] && echo "VM $2 is nonexistent." && return 127

    case "$1" in
        "start" )
            # Parallels Desktop是否已在运行
            ret=$(ps aux | grep prl_client_app | grep -c "Parallels Desktop")
            [[ $ret -eq 0 ]] && open -a "Parallels Desktop"
            # VM是否已运行
            ret=$(prlctl status "$2" | grep -c "running") 
            [[ $ret -eq 0 ]] && prlctl start "$2" || echo "VM $2 is already running."
            ;;
        "stop" )
            ret=$(prlctl status "$2" | grep -c "stopped")
            [[ $ret -eq 0 ]] && prlctl stop "$2" || echo "VM $2 is already stopped."
            ;;
        * )
            echo "ERROR. Usage: <start|stop> VM_NAME"
            ;;
    esac
}