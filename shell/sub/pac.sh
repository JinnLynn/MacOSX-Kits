# 使用GenPAC生成自动代理配置文件
function kits_pac_gen() {
    genpac --config-from=$KITS/cfg/genpac-config.ini --verbose
}

# 生成pac并更新
function kits_pac_update() {
    # pac已经硬链接到gist 和 服务器目录
    gist_repo=/Users/JinnLynn/Developer/Misc/Gist/5001700
    # push到gist要求的改变数量
    push_changed=10
    personal_pac=~/.kits/tmp/pac.js
    # 生成 一个人使用，包括自定义规则的pac文件
    genpac --config-from=$KITS/cfg/genpac-config.ini --output=$personal_pac
    # 上传服务器
    scp $personal_pac $JPAC_SERVER
    # 生成 干净的仅包含gfwlist规则的pac文件
    genpac --config-from=$KITS/cfg/genpac-config.ini --output=$gist_repo/pac.js --user-rule-from=''
    pushd $gist_repo > /dev/null
    # 当改变达到一定数量时自动push到gist
    if [[ $(git diff --numstat pac.js | awk '{print $1}') -gt $push_changed ]]; then 
        git commit -a -m 'updated' 
        git push 
        echo 'gist updated.'
    fi
    popd > /dev/null
}

# 使新的pac立即生效
function kits_pac_effective_immediately() {
    # 改变pac地址路径即可
    sudo networksetup -setautoproxyurl "Wi-Fi" "$JPAC_URL?$(date +%s)"
}