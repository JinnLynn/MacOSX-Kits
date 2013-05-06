#! /usr/bin/env python
# -*- coding: utf-8 -*-
import sys, os, shutil, re, time, json, subprocess
from pprint import pprint

import kits
kits.setDefaultEncodingUTF8()

TASK_FILE = 'task.json'
# 备份服务器
BHOST = os.environ.get('JHOME', '')
# 备份服务器用户名
BUSER = 'root'
# 备份路径 远程服务器上的
BDST = '/volume1/Backup'
# 忽略文件
EXCLUDE = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'excludes.txt')

SSHKEY = os.environ.get('JKEY', None)

logger = None

_exact_progress = True
_quiet = False

def parseTasks():
    task_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), TASK_FILE)
    with open(task_file, 'r') as fp:
        tasks = json.load(fp)
    weekday = int(time.strftime('%w'))
    if weekday == 0:
        weekday = 7
    weekday = '{:02d}'.format(weekday)
    new_tasks = []
    task_names = []
    for task in tasks:
        src = task.get('src', '').strip()
        src = os.path.expanduser(src)
        name = task.get('name', '').strip('/')
        if not src or not name:
            continue
        if not os.path.exists(src):
            logger.warn('\n`{}` is non-existent.\n'.format(src))
            continue
        # 检查任务名是否有相同
        if name in task_names:
            logger.error('duplication of task name: {}'.format(task['name']))
            kits.die()
        task_names.append(name)

        dst = '{}@{}:{}'.format(BUSER, BHOST, os.path.join(BDST, name, 'current'))
        backup_dir = os.path.join(BDST, name, weekday)
        new_tasks.append({
            'src'   : src,
            'dst'   : dst,
            'bak'   : backup_dir,
            'name'  : name
        })
    return new_tasks

def prepare(tasks):
    if not _quiet:
        kits.stdoutCR('Preparing...')
    rm_oldbaks = []
    for task in tasks:
        dst_dir = os.path.dirname(task['bak'])
        rm_oldbaks.append('[[ ! -d {} ]] && mkdir {}; rm -rf {}/*'.format(dst_dir, dst_dir, task['bak']))
    rm_oldbaks_cmd = ['ssh']
    if SSHKEY is not None:
        rm_oldbaks_cmd.extend(['-i', '"{}"'.format(SSHKEY)])
    rm_oldbaks_cmd.append('{}@{}'.format(BUSER, BHOST))
    rm_oldbaks_cmd.append('"{}"'.format('; '.join(rm_oldbaks)))
    rm_oldbaks_cmd = ' '.join(rm_oldbaks_cmd)
    try:
        subprocess.check_call(rm_oldbaks_cmd, shell=True)
    except KeyboardInterrupt, e:
        kits.exit('\n\nCanceled.')
    except Exception, e:
        logger.error(e)
    else:
        if not _quiet:
            kits.stdoutCR('Prepare, done.\n\n')

def backup(task):
    if not _quiet:
        kits.stdout('Backup {}'.format(task['name']))
    try:
        rsync = kits.rsync.RSync(task['src'], task['dst'], sshkey=SSHKEY, 
            backup_dir=task['bak'], exclude=EXCLUDE, quiet=_quiet)
        total, size, elapsed = rsync.run(exact_progress=_exact_progress)
        if size != 0:
            logger.info('%s backup finished. Num: %d, Size: %s Elapsed: %s, Speed: %s, Source: %s',
                task['name'], total, kits.util.hrData(size), kits.util.hrTime(elapsed),
                kits.util.hrData(float(size) / elapsed), task['src'])
        else:
            logger.info('%s backup finished, already up-to-date. Elapsed: %s, Source: %s',
                task['name'], kits.util.hrTime(elapsed), task['src'])
        if not _quiet:
            kits.stdout('')
    except KeyboardInterrupt, e:
        kits.exit('\n\nCanceled.')
    except Exception, e:
        logger.error(e)
        raise e

def main():
    global _exact_progress, _quiet, logger
    if '--no-exact-progress' in sys.argv:
        _exact_progress = False
    if '--quiet' in sys.argv:
        _quiet = True 
    logger = kits.getLogger('backup', stdout=False if _quiet else True)
    if not BHOST:
        logger.error('BHOST is non-existent.')
        kits.die()
    tasks = parseTasks()
    prepare(tasks)
    map(lambda t: backup(t), tasks)

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt, e:
        pass
    # except Exception, e:
    #     raise e
    