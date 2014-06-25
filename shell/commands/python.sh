# 在系统级别上操作pip
kits_python_pip_system() {
    # 允许pip安装系统级的包
    unset PIP_REQUIRE_VIRTUALENV
    unset PIP_RESPECT_VIRTUALENV
    local cmd=""
    until [[ -z "$1" ]]; do
        cmd="$cmd $1"
        shift
    done
    pip $cmd
    # 禁止pip安装系统级的包 即只能在虚拟环境中安装
    export PIP_REQUIRE_VIRTUALENV=true
    export PIP_RESPECT_VIRTUALENV=true
}