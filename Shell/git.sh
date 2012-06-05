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
function new_repo() {
    if [ -z "$1" ]; then
        echo "ERROR. USAGE: <reponame>"
        exit
    fi
    if [ -d "$1" ]; then
        echo "ERROR. '$1' existed."
        exit
    fi
    git init $1
    cd $1
    touch README.md
    echo -e "$DEF_GITIGNORE" > .gitignore
    git add .
    git commit -m 'First commit.'
}

# 在服务端创建新的git repo ( --bare )
function new_server_repo() {
    if [ -z "$1" ]; then
        echo "ERROR. USAGE: <reponame>"
        exit
    fi
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

case "$1" in
    'newrepo' )
        new_repo $2
        ;;
    'newserverrepo' )
        new_server_repo $2
        ;;
    * )
        echo "ERROR. Usage: <newrepo|newserverrepo> [arg]"
        ;;
esac