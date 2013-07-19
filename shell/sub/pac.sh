# 使用GenPAC生成自动代理配置文件
function kits_pac_gen() {
    python $KITS/extra/genpac/genpac.py
}

# 生成pac并更新
function kits_pac_update() {
    # pac已经硬链接到gist 和 服务器目录
    gist_repo=/Users/JinnLynn/Developer/Misc/Gist/5001700
    # push到gist要求的改变数量
    push_changed=10
    # 生成
    kits_pac_gen
    # 上传服务器
    scp $gist_repo/pac.js $JPAC_SERVER
    pushd $gist_repo > /dev/null
    # 当改变达到一定数量时自动push到gist
    if [[ $(git diff --numstat pac.js | awk '{print $1}') -gt $push_changed ]]; then 
        git commit -a -m 'updated' 
        git push 
        echo 'gist updated.'
    fi
    popd > /dev/null
}
