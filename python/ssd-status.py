#! /usr/bin/env python
# -*- coding:utf-8 -*-
# SSD磁盘状态

import subprocess
from pprint import pprint
from datetime import datetime
import time

import kits

disks = [
    ['/dev/disk0', '2011-09-03']
]

_output_tepl = '''
　　　　设备: {device}
　　启用日期: {start_date}
　　健康指示: {wearout}
　数据已写入: {write}
　数据已读取: {read}
有效保留空间: {reservd}
理论可写数据: {can_write}
理论可用时间: {can_use}
'''

def main():
    # 检查 smartctl 是否存在
    try:
        subprocess.check_output(['which', 'smartctl'])
    except Exception, e:
        kits.die('出错了, 没有找到 smartctl, 访问 www.smartmontools.org')

    for disk in disks:
        try:
            info = {}
            start_date = datetime.strptime(disk[1], '%Y-%m-%d')
            output = subprocess.check_output(['smartctl', '-s', 'on', '-a', disk[0]])
            for line in output.split('\n'):
                if 'Rotation Rate' in line and 'Solid State Device' not in line:
                    print('不是SSD磁盘，无法查看其状态。')
                    break
                # 写入
                if 'Host_Writes_32MiB' in line:
                    info['write'] = int(line.split()[9]) * 65536 * 512
                # 读取
                if 'Host_Reads_32MiB' in line:
                    info['read'] = int(line.split()[9]) * 65536 * 512
                # 健康度
                if 'Media_Wearout_Indicator' in line:
                    info['wearout'] = int(line.split()[3]) / 100.0
                # 剩余的保留空间
                if 'Available_Reservd_Space' in line:
                    info['reservd'] = int(line.split()[3]) / 100.0
            if info:
                info['device'] = disk[0]
                # 预计可写
                info['can_write'] = info['write'] / (1 - info['wearout']) - info['write']
                # 预计可用天数
                pass_day = (datetime.today() - start_date).days
                info['can_use'] = pass_day / (1 - info['wearout']) - pass_day

                info['start_date'] = start_date
                info['write'] = kits.util.hrData(info['write'])
                info['read'] = kits.util.hrData(info['read'])
                info['wearout'] = '{:.2%}'.format(info['wearout'])
                info['reservd'] = '{:.2%}'.format(info['reservd'])
                info['can_write'] = kits.util.hrData(info['can_write'])
                if info['can_use'] > 365:
                    info['can_use'] = '{:.2f}年'.format( info['can_use'] / 365.0 )
                else:
                    info['can_use'] = '{:.2f}天'.format( info['can_use'] )
                print(_output_tepl.format(**info))
        except Exception, e:
            # raise e
            print('出错了: {}'.format(e))

if __name__ == '__main__':
    main()