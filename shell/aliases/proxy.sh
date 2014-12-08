# 代理相关

# proxy
alias proxy.start="kits_home_socks start; kits_goagent start"
alias proxy.stop="kits_home_socks stop; kits_goagent stop"
alias proxy.alive="kits_home_socks alive; kits_goagent alive"
alias proxy.test="kits_home_socks test; kits_goagent test"
alias proxy.keep-alive="kits_home_socks keep-alive; kits_goagent keep-alive"
# goagent
alias goa.log="kits_goagent log"

# 自动代理配置文件
alias pac.gen="kits_pac_gen"
alias pac.update="kits_pac_update"
alias pac.effect="kits_pac_effective_immediately"
alias pac.url="networksetup -getautoproxyurl Wi-Fi | grep URL | awk '{print \$2}'"
alias pac.url.test="kits.url \"\$(pac.url)\""
alias pac.url.open="open \"\$(pac.url)\""

# 使用代理下载文件
alias proxy.dl="cd ~/Downloads && curl -O# --socks5 127.0.0.1:$PROXY_SOCKS_PORT"
alias proxy.dl.ga="cd ~/Downloads && curl -O# --proxy 127.0.0.1:$PROXY_GOAGENT_PORT"

# 家
alias proxy.home.start="kits_ssh_proxy start $JPROXY_HOME_SOCKS_PORT $JHOME"
alias proxy.home.stop="kits_ssh_proxy stop $JPROXY_HOME_SOCKS_PORT"
alias proxy.home.alive="kits_ssh_proxy alive $JPROXY_HOME_SOCKS_PORT"
alias proxy.home.watch="kits_ssh_proxy watch $JPROXY_HOME_SOCKS_PORT"
alias proxy.home.test="ssh -v $JHOME \"exit\""

# privoxy
alias privoxy.start="kits_privoxy start"
alias privoxy.stop="kits_privoxy stop"
# squid
alias squid.start="kits_squid start"
alias squid.stop="kits_squid stop"
alias squid.restart="kits_squid restart"
alias squid.alive="kits_squid alive"