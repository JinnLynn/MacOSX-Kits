# 服务器相关

# MAMP控制
alias mamp.start="kits_mamp start"
alias mamp.stop="kits_mamp stop"
alias mamp.restart="kits_mamp restart"
alias mamp.reload="kits_mamp reload"
alias mamp.alive="kits_mamp alive"

# MEMP控制
alias memp.start="kits_memp start"
alias memp.stop="kits_memp stop"
alias memp.restart="kits_memp restart"
alias memp.reload="kits_memp reload"
alias memp.alive="kits_memp alive"

# Gude
alias gd.env="pve.on gude"
alias gd.install="gd.env && python setup.py install && cd -"
alias gd="gude"
alias gd.init="gd init"
alias gd.add="gd add"
alias gd.build="gd build"
alias gd.publish="gd publish"
alias gd.serve="gd serve"
alias gd.local="gd build -lp"
alias gd.remote="gd publish -b && _extra/sync"

