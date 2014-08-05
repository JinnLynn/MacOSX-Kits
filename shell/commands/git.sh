# 生成.gitignore文件
kits_git_ignore() {
    local def_gitignore=$(cat <<EOF
# Personal
*.log
tmp/

# Python
*.py[cod]

# Windows
# REF: https://github.com/github/gitignore/blob/master/Global/Windows.gitignore
Desktop.ini
Thumbs.db
ehthumbs.db
$RECYCLE.BIN/

# MacOSX 
# REF: https://github.com/github/gitignore/blob/master/Global/OSX.gitignore
.DS_Store
._*
.Spotlight-V100
.Trashes
.AppleDouble
.LSOverride
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
Icon


#!!! Icon must end with two \r
EOF)
    echo -e "$def_gitignore" > .gitignore
}

# 在本地创建新的git repo
kits_git_new_repo() {
    [[ -z "$1" ]] && echo "ERROR. USAGE: <reponame>" && return
    [[ -d "$1" ]] && echo "ERROR. '$1' existed." && return 
    git init $1
    cd $1
    echo $1 > README.md
    kits_git_ignore
    git add .
    git commit -m 'first commit.'
}

# 在服务端创建新的git repo ( --bare )
kits_git_new_server_repo() {
    [[ -z "$1" ]] && echo "ERROR. USAGE: <reponame>" && return
    # 确保是以.git结尾
    local reponame=$1
    [[ ! -z "${reponame##*\.git}" ]] && reponame="$reponame.git"

    # REF: http://stackoverflow.com/questions/7114990/pseudo-terminal-will-not-be-allocated-because-stdin-is-not-a-terminal
    ssh -t -t -p $JHOME_SSH_PORT scm@$JHOME <<EOF
    cd /git
    [[ -d "$reponame" ]] && echo "ERROR. '$reponame' existed." && exit
    git init --bare $reponame
    exit
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