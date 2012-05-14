#!/bin/sh

#脚本工作目录
if [ -L $0 ]; then
    SCRIPTPATH=$(dirname $(ls -l $0 | awk '{print $11}'))
else
    SCRIPTPATH=$(cd '$(dirname '$0')'; pwd)
fi

#备份服务器SSH
BHOST=backup@10.0.0.1
#备份路径 远程服务器上的
BDST=/volume1/Backup

#SSH密钥 密钥的导入通过 ssh-add 
SSHKEY=~/.ssh/keys/jnas-key

#忽略的文件列表文件
EXCLUDE=$SCRIPTPATH/excludes

#日志
LOGFILE=$SCRIPTPATH/log/$(date +%Y%m%d).log

#SSH密钥代理SOCKET 在cron中必须设置，否则无法成功备份
export SSH_AUTH_SOCK=$( ls /tmp/launch-*/Listeners )

#处理备份的函数 
#参数1: 要备份的文件夹路径 注意：最好以“/”结尾
#参数2: 备份的名称，用于在服务端建立文件夹
#参数3: 备份NAS上的文件
function backup() {
	echo "------------------------------------------------" >> $LOGFILE
	#检查目录是否已存在，如果没有建立目录
	ssh $BHOST "if [ ! -d $BDST/$2 ]; then mkdir $BDST/$2 ; chown -R backup:users $BDST/$2 ; chmod -R 744 $BDST/$2 ; fi"
	#被修改回删除的文件保存处理 每天生成一个目录
	BDIR="$BDST/$2/$(date +0%u)"
	OPTS="-av --force --ignore-errors --delete --backup --backup-dir=$BDIR"
	SSH_OPT="-e ssh"
	EXCULDE_OPT="--exclude-from=$EXCLUDE"
	#清除旧的增量备份数据
	rsync --delete -a $SCRIPTPATH/.emptydir/ $BHOST:$BDIR
	#同步文件
	if [ $3 = nas ]; then
		#同步NAS上文件
		echo $3
		ssh $BHOST "rsync $OPTS $1 $BDST/$2/current" >> $LOGFILE
	else
		#同步本地文件
		rsync $OPTS $EXCULDE_OPT $SSH_OPT $1 $BHOST:$BDST/$2/current >> $LOGFILE
	fi
	
	echo "------------------------------------------------" >> $LOGFILE
	echo "$(date +"%H:%M:%S") $2 ok\n\n" >> $LOGFILE
}

echo "$(date +"%H:%M:%S") backup start\n" >> $LOGFILE

#创建空目录 用于清空旧的日增量变化备份
[ -d $SCRIPTPATH/.emptydir ] || mkdir $SCRIPTPATH/.emptydir

#以下为备份列表 格式：backup 备份文件夹绝对路径 备份名
#注意：备份文件夹路径最好以'/'结束
#------------------------------------------------------------------------#


#JMBP
#备份iTunes
backup /Users/JinnLynn/Music/iTunes/ JMBP.iTunes

#备份Developer
backup /Users/JinnLynn/Developer/ JMBP.Developer

#备份Documents
backup /Users/JinnLynn/Documents/ JMBP.Documents

#备份Applications
backup /Applications/ JMBP.Applications

#备份Pictures
backup /Users/JinnLynn/Pictures/ JMBP.Pictures

#JMBPWin
backup /Volumes/BOOTCAMP/Users/JinnLynn/Developer/ JMBPWin.Developer

#JNAS SCMs
backup /volume1/DevCenter/SCMs/ JNAS.SCMs nas


#------------------------------------------------------------------------#

#删除空目录
rmdir $SCRIPTPATH/.emptydir

echo "$(date +"%H:%M:%S") backup finish\n\n" >> $LOGFILE