# 使用GenPAC生成自动代理配置文件
kits_pac_gen() {
    genpac --config-from=$KITS/config/genpac-config.ini --proxy="$PAC_PROXY_LOCAL" --output="$KITS_TMP/pac4local.js" --verbose
}

# 生成pac并更新
kits_pac_update() {
    # pac已经硬链接到gist 和 服务器目录
    gist_repo=/Users/JinnLynn/Developer/Misc/Gist/5001700
    # push到gist要求的改变数量
    push_changed=15
    # 生成 个人使用，包括自定义规则的pac文件
    genpac --config-from=$KITS/config/genpac-config.ini --proxy="$PAC_PROXY_LOCAL" --output="$KITS_TMP/pac4local.js"
    genpac --config-from=$KITS/config/genpac-config.ini --proxy="$PAC_PROXY_LAN"  --output="$KITS_TMP/pac4lan.js"
    # 上传服务器
    for f in $(ls ~/.kits/tmp/pac*.js); do
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
    # aliyun oss 私有bucket，每次生成有效期一年 31536000 的地址
    url=$(osscmd sign oss://$OSS_PRIVATE_BUCKET/pac4local.js --timeout=31536000 2>/dev/null | grep $OSS_PRIVATE_BUCKET)
    sudo networksetup -setautoproxyurl "Wi-Fi" "$url"
}

kits_pac_current_url() {
    echo $(networksetup -getautoproxyurl "Wi-Fi" | grep URL | awk '{print $2}')
}