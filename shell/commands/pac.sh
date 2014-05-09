# 使用GenPAC生成自动代理配置文件
kits_pac_gen() {
    genpac --config-from=$KITS/config/genpac-config.ini --verbose
}

# 生成pac并更新
kits_pac_update() {
    # pac已经硬链接到gist 和 服务器目录
    gist_repo=/Users/JinnLynn/Developer/Misc/Gist/5001700
    # push到gist要求的改变数量
    push_changed=15
    # 生成 个人使用，包括自定义规则的pac文件
    genpac --config-from=$KITS/config/genpac-config.ini
    # genpac --config-from=$KITS/config/genpac-config.ini --proxy="$PAC_PROXY_LAN"  --output="$KITS_TMP/pac4lan.js"
    # 上传服务器
    for f in $(ls $KITS/tmp/pac*.js); do
        osscmd put $f oss://$OSS_PRIVATE_BUCKET 2>/dev/null | grep URL | awk '{print $6}'
    done
    # 生成 干净的仅包含gfwlist规则的pac文件
    genpac --config-from=$KITS/config/genpac-config.ini --output=$gist_repo/pac.js --user-rule-from=''
    pushd $gist_repo > /dev/null
    # git diff  pac.js
    added=$(git diff --numstat pac.js | awk '{print $1}')
    deleted=$(git diff --numstat pac.js | awk '{print $2}')
    echo "added: $added deleted: $deleted"
    ((changed=$added+$deleted))
    # 当改变达到一定数量时自动push到gist
    if [[ $changed -gt $push_changed ]]; then 
        git commit -a -m 'updated' 
        git push 
        echo 'gist updated.'
    fi
    popd > /dev/null
}

# 使新的pac立即生效
kits_pac_effective_immediately() {
    # 改变pac地址路径
    timeout=31536000
    while [[ true ]]; do
        # 改变timeout 防止短时间内生成的地址都相同
        ((timeout=timeout+1))
        # aliyun oss 私有bucket，每次生成有效期一年 31536000 的地址
        url=$(osscmd sign oss://$OSS_PRIVATE_BUCKET/pac4jmbp.js --timeout=$timeout 2>/dev/null | grep $OSS_PRIVATE_BUCKET)
        # osscmd 生成的的签名地址对特殊字符进行%xx类似的转义
        # 系统在使用这些地址获取pac时又对字符%再次进行转义
        # 由此造成获取pac时签名错误
        # 因此这里需要去除转义后再存储地址
        url=$(python -c "import urllib; print urllib.unquote('$url')")
        # echo $url
        # URL地址中字符`+`被认为是空格，不会被转义为%2B，因此也会早签名错误
        # 这里剔除包含+的url
        url=${url##*+*}
        [[ ! -z "$url" ]] && break
    done
    echo "PAC URL: $url"
    sudo networksetup -setautoproxyurl "Wi-Fi" "$url"
}