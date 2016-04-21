# SSH相关

# SSH秘钥 SOCK等重置
alias ssh.reset="kits_ssh_reset"
# SSH端口转发
alias ssh.lpf="kits_ssh_port_forward local"
alias ssh.rpf="kits_ssh_port_forward remote"
alias ssh.dpf="kits_ssh_port_forward dynamic"
alias ssh.cpf="kits_ssh_port_forward close"
# SSH快速连接
alias ssh.home="ssh -p $JHOME_SSH_PORT root@$JHOME"
alias ssh.home.jl="ssh -p $JHOME_SSH_PORT JinnLynn@$JHOME"
alias ssh.home.scm="ssh -p $JHOME_SSH_PORT scm@$JHOME"
alias ssh.work="ssh jinnlynn@172.16.5.14"
alias ssh.work.scm="ssh scm@172.16.5.14"
alias ssh.github="ssh -T git@github.com"
alias ssh.ubuntu="ssh jinnlynn@10.211.55.11"
alias ssh.jeeker="ssh $JJEEKER_SRV"
alias ssh.rpi="ssh pi@$JRPI"
alias ssh.corp="ssh $JCORP_SRV"
# citypuzzle.org
alias ssh.cp="ssh $JCP_SRV"

# 家
# 本地端口转发
# xiaolu VNC
alias home.vnc="ssh.lpf 60010:10.95.27.3:5900 && open vnc://localhost:60010"
alias home.vnc.off="ssh.cpf 60010"
# 路由器管理
alias home.router="ssh.lpf 60020:10.95.27.10:80 && open http://localhost:60020"
alias home.router.off="ssh.cpf 60020"
# NAS Web Admin
alias home.nas="ssh.lpf 60030:10.95.27.1:5051 && open https://localhost:60030"
alias home.nas.off="ssh.cpf 60030"
# NAS share
alias home.nas.share="ssh.lpf 60040:10.95.27.1:548 && open afp://localhost:60040"
alias home.nas.share.off="ssh.cpf 60040"

# Digital Ocean 
alias ssh.do="ssh root@$DO_HOST"
alias ssh.do.reboot="ssh.do \"reboot\""