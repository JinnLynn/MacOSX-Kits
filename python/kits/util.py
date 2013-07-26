# -*- coding: utf-8 -*-
import os

def hrData(byte):
    try:
        byte = int(byte)
    except:
        byte = 0
    size = byte / 1024.0
    unit = 'KB'
    if size > 1024:
        size = size / 1024.0
        unit = 'MB'
    if size > 1024:
        size = size / 1024.0
        unit = 'GB'
    if size > 1024:
        size = size / 1024.0
        unit = 'TB'
    return '{:.2f}{}'.format(size, unit)

def hrTime(seconds):
    try:
        seconds = int(seconds)
    except Exception, e:
        seconds = 0
    h = 0
    m = 0
    s = seconds % 60
    m = int(seconds / 60)
    if m >= 60:
        m = m % 60
        h = int(m / 60)
    return '{:02d}:{:02d}:{:02d}'.format(h,m,s)

def getTerminalSize():
    env = os.environ
    def ioctl_GWINSZ(fd):
        try:
            import fcntl, termios, struct, os
            cr = struct.unpack('hh', fcntl.ioctl(fd, termios.TIOCGWINSZ, '1234'))
        except:
            return
        return cr
    cr = ioctl_GWINSZ(0) or ioctl_GWINSZ(1) or ioctl_GWINSZ(2)
    if not cr:
        try:
            fd = os.open(os.ctermid(), os.O_RDONLY)
            cr = ioctl_GWINSZ(fd)
            os.close(fd)
        except:
            pass
    if not cr:
        cr = (env.get('LINES', 25), env.get('COLUMNS', 80))
    return int(cr[1]), int(cr[0])

def colorStringGreen(s):
    return '\033[32m{}\033[39m'.format(s)

def colorStringRed(s):
    return '\033[31m{}\033[39m'.format(s)