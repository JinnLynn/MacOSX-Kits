# 默认`.gitignore`文件内容
DEF_GITIGNORE=$(cat <<EOF
# Windows
[Dd]esktop.ini
[Tt]humbs.db
\$RECYCLE.BIN/

# MacOSX
.DS_Store
._*
.Spotlight-V100
.Trashes
EOF)

# 在本地创建新的git repo
kits_git_new_repo() {
    [[ -z "$1" ]] && echo "ERROR. USAGE: <reponame>" && return
    [[ -d "$1" ]] && echo "ERROR. '$1' existed." && return 
    git init $1
    cd $1
    echo $1 > README.md
    echo -e "$DEF_GITIGNORE" > .gitignore
    git add .
    git commit -m 'first commit.'
}

# 在服务端创建新的git repo ( --bare )
kits_git_new_server_repo() {
    [[ -z "$1" ]] && echo "ERROR. USAGE: <reponame>" && return
    # 确保是以.git结尾
    reponame=$1
    if [ ! -z "${reponame##*\.git}" ]; then
        reponame="$reponame.git"
    fi

    ssh scm@$JHOST <<EOF
    cd /git
    if [ -d "$reponame" ]; then
        echo "ERROR. '$reponame' existed."
        exit
    fi
    git init --bare $reponame
EOF
}

# 更新~/Developer/SCMs下的所有版本库
kits_pull_all_scms() {
    pushd ~/Developer/SCMs >/dev/null
    for item in *; do
        if [[ -d "$item" && -d "$item/.git" ]]; then
            cd $item
            git pull > /dev/null
            _kits_check "$item update..."
            cd -  >/dev/null
        fi
    done 
    popd >/dev/null
}