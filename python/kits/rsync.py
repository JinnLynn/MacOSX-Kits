# -*- coding: utf-8 -*-
import os, subprocess, time, re

import core, util

_rsync_bin = '/usr/local/bin/rsync'
_std_pipe = {
        'stdin'     : subprocess.PIPE,
        'stdout'    : subprocess.PIPE,
        'stderr'    : subprocess.PIPE
    }

class RSync(object):
    def __init__(self, source, destination, rsync=_rsync_bin, backup_dir=None, 
        exclude=None, compress=True, progress=True):
        self.source = source
        self.destination = destination
        self.output_enabled = progress
        self.default_cmd = [rsync, '-a', '--force', '--delete', '--ignore-errors']

        if compress:
            self.default_cmd.append('-z')
        if backup_dir is not None:
            self.default_cmd.extend(['--backup', '--backup-dir={}'.format(backup_dir)])
        if exclude is not None:
            if os.path.isfile(exclude):
                self.default_cmd.append('--exclude-from={}'.format(exclude))
            else:
                self.default_cmd.append('--exclude={}'.format(exclude))

    def output(self, msg, new_line=False):
        if not self.output_enabled:
            return
        if new_line:
            core.stdout(msg)
        else:
            core.stdoutCR(msg)

    def dryRun(self):
        # DRY-RUN 获取文件数及所有文件大小
        self.output('Counting files number...')
        cmd = list(self.default_cmd)
        cmd.extend(['--stats', '--dry-run', self.source, self.destination])
        try:
            proc = subprocess.Popen(cmd, **_std_pipe)
            ret = proc.wait()
            if ret!=0:
                raise subprocess.CalledProcessError(ret, ' '.join(cmd))
            res = proc.stdout.read()
            total_num = int(re.findall(r'Number of files: (\d+)', res)[0])
            total_size = int(re.findall(r'Total file size: (\d+)', res)[0])
        except Exception, e:
            self.saveTerminate(proc)
            raise e
        self.output('Counting files number: {}, done.'.format(total_num))
        self.output('', True)
        # 返回 所有文件数量,所有文件累计大小
        return total_num, total_size

    def outputProgressMsg(self, finished_num, total_num, finished_size, start_time):
        passed_time = time.time() - start_time
        try:
            progress = float(finished_num) / float(total_num)
            speed = float(finished_size) / passed_time
        except Exception, e:
            progress = 1.0
        if progress<0 or progress>1:
            progress = 1.0
        self.output('{:.2%} ({}/{}) {} | {}/s'.format(
                        progress, finished_num, total_num, 
                        util.hrData(finished_size), util.hrData(speed) ))

    def run(self, exact=True):
        # 精确统计需先dry-run
        total_num = 0
        total_size = 0
        if exact:
            total_num, total_size = self.dryRun()
        self.output('Checking...')
        start_time = time.time()
        finished_size = 0
        cmd = list(self.default_cmd)
        cmd.extend(['--progress', self.source, self.destination])
        try:
            proc = subprocess.Popen(cmd, **_std_pipe)
            while True:
                retcode = proc.poll()
                if retcode is not None:
                    # rsync未成功执行
                    if retcode != 0:
                        raise subprocess.CalledProcessError(retcode, ' '.join(cmd))
                    break
                res = proc.stdout.readline().strip()
                # print(output)
                if 'to-check' in res:
                    s = re.findall(r'(\d+) +100%', res)
                    size = int(s[0]) if s else 0
                    finished_size = finished_size + size
                    m = re.findall(r'to-check=(\d+)/(\d+)', res)
                    finished_num = int(m[0][1]) - int(m[0][0])
                    if not exact:
                        total_num = int(m[0][1])
                    self.outputProgressMsg(finished_num, total_num, finished_size, start_time)
        except Exception, e:
            self.saveTerminate(proc)
            raise e
        if finished_size == 0:
            self.output('Already up-to-date.')
        else:
            self.outputProgressMsg(total_num, total_num, finished_size, start_time)
        self.output('', True)
        return total_num, finished_size, time.time()-start_time

    def saveTerminate(self, proc):
        try:
            proc.terminate()
        except:
            pass
    