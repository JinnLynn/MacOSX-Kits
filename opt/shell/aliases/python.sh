# Python相关

# pylint
alias pylint="pylint --output-format=colorized"
alias pylint.msg="pylint --help-msg"

# 临时运行在系统级别上使用pip
alias pip.sys="kits_python_pip_system"

# Python 虚拟环境
# 建立
alias pve.mk="mkvirtualenv"
alias pve.mk.tmp="mktmpenv"
# 建立 基于python3
alias pve3.mk="pve.mk --python=/usr/local/bin/python3"
alias pve3.mk.tmp="pve.mk.tmp --python=/usr/local/bin/python3"
# 启用与退出
alias pve.on="workon"
alias pve.exit="deactivate"
# 名称 列表 目录 拷贝 删除
alias pve.name="[[ -d \"\$VIRTUAL_ENV\" ]] && basename \$VIRTUAL_ENV || echo \"no VIRTUAL_ENV\""
alias pve.ls="lsvirtualenv"
alias pve.ls.sp="lssitepackages"
alias pve.cd="cdvirtualenv"
alias pve.cd.sp="cdsitepackages"
alias pve.cd.proj="cdproject"
alias pve.cp="cpvirtualenv"
alias pve.rm="rmvirtualenv"
# 设置项目目录
alias pve.setpath="setvirtualenvproject"
# 清理 删除安装的模块
alias pve.clean="wipeenv"
# 进入virtual env目录
alias pve.dir="[[ -d \"\$VIRTUAL_ENV\" ]] && (cd \$VIRTUAL_ENV; pwd) || echo \"no VIRTUAL_ENV\""