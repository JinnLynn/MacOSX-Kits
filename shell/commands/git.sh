# 生成.gitignore文件
kits_git_ignore() {
    local def_gitignore=$(cat <<EOF
# Personal
*.log
*.tmp
tmp/

# Python
__pycache__/
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
.AppleDouble
.LSOverride
#! Icon must end with two \\\\r
Icon


._*
.Spotlight-V100
.Trashes
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk
EOF)
    echo -n "$def_gitignore" > .gitignore
}

# 生成LICENSE (the MIT license)
kits_git_mit_license() {
    local owner="Jian Lin(JinnLynn <eatfishlin@gmail.com>)"
    local def_license=$(cat <<EOF
The MIT License (MIT)

Copyright (c) $(date +%Y) $owner

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF)
    echo -n "$def_license" > LICENSE
}

# 在本地创建新的git repo
kits_git_new_repo() {
    [[ -z "$1" ]] && echo "ERROR. USAGE: <reponame>" && return
    [[ -d "$1" ]] && echo "ERROR. '$1' existed." && return 
    git init $1
    cd $1
    echo "# $1" > README.md
    kits_git_ignore
    kits_git_mit_license
    git add .
    git commit -m 'initial commit'
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