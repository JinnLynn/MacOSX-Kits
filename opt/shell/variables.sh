# 默认的日志目录
export KITS_LOG="$KITS/var/log"
# 默认临时目录
export KITS_TMP="$KITS/var/tmp" 
# 缓存目录
export KITS_CACHE="$KITS/var/cache"
# 运行目录
export KITS_RUN="$KITS/var/run"

# 检查目录
[[ ! -d $KITS_LOG ]] && rm -rf $KITS_LOG && ln -s $HOME/Library/Logs/kits log && mkdir -p $HOME/Library/Logs/kits
for _f in "$KITS_TMP" "$KITS_CACHE" "$KITS_RUN"; do
    [[ ! -d $_f ]] && mkdir -p $_f && chmod -R 755 $_f
done

[[ -e $KITS/etc/vars.sh ]] && . $KITS/etc/vars.sh

# 载入私有环境变量
[[ -e $KITS/root/etc/vars.sh ]] && . $KITS/root/etc/vars.sh 
