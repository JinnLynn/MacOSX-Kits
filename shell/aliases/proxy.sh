# 代理相关

# proxy
alias proxy.start="kits_ssh_proxy start; kits_polipo start"
alias proxy.stop="kits_ssh_proxy stop; kits_polipo stop"
alias proxy.alive="kits_ssh_proxy alive; kits_polipo alive"
alias proxy.test="kits_ssh_proxy test; kits_polipo test"
alias proxy.keep-alive="kits_ssh_proxy keep-alive; kits_polipo keep-alive"
alias proxy.config="scutil --proxy | grep '^\ '"

alias proxy.ter.on="export http_proxy=\"http://127.0.0.1:$PROXY_HTTP_PORT/\"; export https_proxy=\"http://127.0.0.1:$PROXY_HTTP_PORT/\";"
alias proxy.ter.off="unset http_proxy; unset https_proxy"
# goagent
# alias goa.log="kits_goagent log"
# Tor
# alias tor.start="kits_tor start"
# alias tor.stop="kits_tor stop"
# alias tor.alive="kits_tor alive"
# alias tor.keep-alive="kits_tor keep-alive"
# alias tor.test="kits_tor test"
# alias tor.watch="kits_tor watch"

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
alias proxy.home.test="ssh -v $JHOME \"exit\""/Volumes/OSXYosemite/Users/JinnLynn/Developer/Misc/Kits/OSX/private/shell-alias.sh

# # privoxy
# alias privoxy.start="kits_privoxy start"
# alias privoxy.stop="kits_privoxy stop"
# alias privoxy.alive="kits_privoxy alive"
# alias privoxy.keep-alive="kits_privoxy keep-alive"
# alias privoxy.test="kits_privoxy test"
# # squid
# alias squid.start="kits_squid start"
# alias squid.stop="kits_squid stop"
# alias squid.restart="kits_squid restart"
# alias squid.alive="kits_squid alive"

# VPN
alias vpn.start="kits_vpn start"
alias vpn.stop="kits_vpn stop"
alias vpn.alive="kits_vpn alive"
alias vpn.keep-alive="kits_vpn keep-alive"