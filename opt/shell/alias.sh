alias ll="ls -lGh"
alias la="ls -lAGh"
alias grep="grep --color=auto"
alias cd-="cd - >/dev/null"
alias open.="open ."

alias reload!="exec $SHELL" # "[[ -f ~/.bashrc ]] && . ~/.bashrc"
alias alive="for _f in \$ALIVE_CHECK_FUNC; do \$_f alive; done"
alias af="alias | awk '{print substr(\$0,index(\$0, \" \")+1,length())}' | grep"

for _f in $(ls $(dirname $BASH_SOURCE)/aliases/*.sh 2>/dev/null); do . $_f; done 

# 载入私有别名
[[ -f $KITS/root/opt/shell/alias.sh ]] && . $KITS/root/opt/shell/alias.sh
