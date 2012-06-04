#!/bin/sh

#配置
#------------------------------------------------------------------------#

#备份服务器SSH 如 backup@10.0.0.1
BHOST=backup@$JHOST

#备份路径 远程服务器上的
BDST=/volume1/Backup

#SSH密钥文件 如 /Users/JinnLynn/.ssh/jkey
SSHKEY=$JKEY

#忽略的文件列表文件
EXCLUDE=./excludes.txt

#日志目录
LOGDIR=./log

#配置结束
#------------------------------------------------------------------------#

#处理备份的函数 
#参数1: 要备份的文件夹路径 注意：最好以“/”结尾
#参数2: 备份的名称，用于在服务端建立文件夹
#参数3: 备份NAS上的文件
function single_backup() {
	#被修改回删除的文件保存处理 每天生成一个目录
	BDIR="$BDST/$2/$(date +0%u)"
	OPTS="-av --force --ignore-errors --delete --backup --backup-dir=$BDIR"
	SSH_OPT="ssh -i $SSHKEY"
	EXCULDE_OPT="--exclude-from=$EXCLUDE"

	echo "$(date +"%H:%M:%S") $2 start"
	echo "------------------------------------------------"

	#检查目录是否已存在，如果没有建立目录
	$SSH_OPT $BHOST "[ -d $BDST/$2 ] || mkdir $BDST/$2" < /dev/null
	
	#清除旧的增量备份数据
	rsync --delete -a $SCRIPTPATH/.emptydir/ $BHOST:$BDIR
	#同步文件
	if [ "$3" = 'nas' ]; then
		#同步NAS上文件
		$SSH_OPT $BHOST "rsync $OPTS $1 $BDST/$2/current"
	else
		#同步本地文件
		rsync $OPTS $EXCULDE_OPT -e "$SSH_OPT" $1 $BHOST:$BDST/$2/current
	fi
	
	echo "------------------------------------------------"
	echo "$(date +"%H:%M:%S") $2 ok\n\n"
}

function backup() {

	#创建空目录 用于清空旧的日增量变化备份
	[ -d .emptydir ] || mkdir .emptydir

	echo "$(date +"%H:%M:%S") backup start\n"

	# 读取计划列表 开始备份

	while read LINE
	do
		if [ "${LINE:0:1}" != "" -a "${LINE:0:1}" != "#" ]; then
			single_backup $LINE 
		fi
	done < task.txt

	#删除空目录
	rmdir .emptydir

	echo "$(date +"%H:%M:%S") backup finish\n\n"
}

#------------------------------------------------------------------------#

#脚本工作目录
if [ -L $0 ]; then
    SCRIPTPATH=$(dirname $(ls -l $0 | awk '{print $11}')) #由链接文件访问    
else
    SCRIPTPATH=$(cd $(dirname $0); pwd) #由直接访问
fi

#SSH密钥代理SOCKET 在cron中必须设置，否则无法成功备份
if [ -z $SSH_AUTH_SOCK ]; then
	export SSH_AUTH_SOCK=$( ls /tmp/launch-*/Listeners )
fi

#进入工作目录
cd $SCRIPTPATH

#建立日志目录
[ -d "$LOGDIR" ] || mkdir "$LOGDIR"

#日志文件
LOGFILE="$LOGDIR/$(date +%Y%m%d-%H%M%S).log"
# COUNTER=1
# while [ -f "$LOGFILE" ]; do
#     LOGFILE="$LOGDIR/$(date +%Y%m%d)-$COUNTER.log"
#     COUNTER=$(($COUNTER+1))
# done

backup | tee -a "$LOGFILE"