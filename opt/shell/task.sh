# 环境
. ~/.bashrc 2>/dev/null

export KITS_TASK_RUNNING=true

# kits_task_mv_dropbox() {
#     filter=""
# }

# 日期输出
task_kits_date() {
    d=$(date "+%Y-%m-%d %H:%M:%S,000")
    echo -e "\n\n$d: $1\n-----\n"
}

# RunAtLoad
task_load() {
    task_kits_date $FUNCNAME
    # 重置ssh
    ssh.reset
    # 启动代理
    proxy.keep-alive
}

task_minutely() {
    # task_kits_date $FUNCNAME
    proxy.keep-alive
}

task_hourly() {
    task_kits_date $FUNCNAME
    # PAC生成
    pac.gen
}

task_daily() {
    task_kits_date $FUNCNAME
    # brew
    brew update
}

# root 用户
task_root_hourly() {
    task_kits_date $FUNCNAME
    # 日志写入权限
    chown -R JinnLynn /Users/JinnLynn/Library/net.jeeker.kits/
    chmod -R 777 /Users/JinnLynn/Library/net.jeeker.kits/
    # Little Snitch 破解: 
    # 杀死Daemon进程，防止每三小时提示注册
    # echo "kill Little Snitch Daemon"
    # pkill -9 "Little Snitch Daemon"
}

# 其它
# 备份
task_backup() {
    task_kits_date $FUNCNAME
    # 延时一定时间，防止当系统刚从睡眠中恢复时网络不正常，备份失败。
    echo 'Sleep 30s...'
    sleep 30
    # kits.backup --quiet --no-exact-progress
    kits.backup
}