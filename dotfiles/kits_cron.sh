# 用于在Cron中环境的建立

# bash环境变量
. ~/.bashrc

# ssh-agent
# 如果没有，当在Cron中无法使用加密的密钥
if [[ -z "$SSH_AUTH_SOCK" ]]; then
    export SSH_AUTH_SOCK=`find /tmp/ -path '*launch-*' -name 'Listeners' -print 2>/dev/null`
fi