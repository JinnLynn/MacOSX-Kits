#! /usr/bin/env python
# -*- coding: utf-8 -*-
import sys, os, shutil, re, time, json, subprocess
from pprint import pprint

import kits
kits.setDefaultEncodingUTF8()

config_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'config.yaml')
config = kits.loadYAML(config_file)

config['backup_server'] = os.environ.get('JHOME', '')
config['backup_user'] = 'root'
config['backup_dst'] = '/volume1/Backup' 
config['ssh_key'] = os.environ.get('JKEY', None)

logger = None
_exact_progress = True
_quiet = False

def parseTasks():
    weekday = int(time.strftime('%w'))
    if weekday == 0:
        weekday = 7
    weekday = '{:02d}'.format(weekday)
    new_tasks = []
    task_names = []
    for task in config['tasks']:
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

        dst = '{}@{}:{}'.format(config['backup_user'], config['backup_server'], os.path.join(config['backup_dst'], name, 'current'))
        backup_dir = os.path.join(config['backup_dst'], name, weekday)
        new_tasks.append({
            'src'       : src,
            'dst'       : dst,
            'bak'       : backup_dir,
            'name'      : name,
            'filter'    : task.get('filter', []),
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
    if config['ssh_key'] is not None:
        rm_oldbaks_cmd.extend(['-i', '"{}"'.format(config['ssh_key'])])
    rm_oldbaks_cmd.append('{}@{}'.format(config['backup_user'], config['backup_server']))
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
        task['filter'].extend(config['global_filter'])
        rsync = kits.rsync.RSync(task['src'], task['dst'], sshkey=config['ssh_key'], backup_dir=task['bak'], 
            filter_rule=task['filter'], quiet=_quiet)
        # print(rsync.toCmd('--stats', '--dry-run'))
        # return
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
        kits.stdout('{} backup fail.'.format(task['name']));
        # raise e

def main():
    global _exact_progress, _quiet, logger
    if '--no-exact-progress' in sys.argv:
        _exact_progress = False
    if '--quiet' in sys.argv:
        _quiet = True 
    logger = kits.getLogger('backup', stdout=False if _quiet else True)
    if not config['backup_server']:
        logger.error('backup_server is non-existent.')
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
    