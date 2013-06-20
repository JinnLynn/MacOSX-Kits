# -*- coding: utf-8 -*-
import sys, os, logging

import util
import yaml

_log_dir = os.path.expanduser('~/Library/Logs/net.jeeker.kits')
_loggers = {}

def setDefaultEncodingUTF8():
    reload(sys)
    sys.setdefaultencoding('utf-8')
    del sys.setdefaultencoding

def notify(title, subtitle='', text='', sound=True):
    import objc, AppKit
    try:
        app = AppKit.NSApplication.sharedApplication()
        NSUserNotification = objc.lookUpClass("NSUserNotification")
        NSUserNotificationCenter = objc.lookUpClass("NSUserNotificationCenter")
        notification = NSUserNotification.alloc().init()
        notification.setTitle_(title)
        if subtitle:
            notification.setSubtitle_(subtitle)
        if text:
            notification.setInformativeText_(text)
        if sound:
            notification.setSoundName_("NSUserNotificationDefaultSoundName")
        NSUserNotificationCenter.defaultUserNotificationCenter().scheduleNotification_(notification)
    except Exception, e:
        pass

# line feed
def stdout(msg=''):
    sys.stdout.write('{}\n'.format(msg))
    sys.stdout.flush()

# carriage return
def stdoutCR(msg=''):
    _, width = util.getTerminalSize()
    clear = '\r{:%d}' % width
    sys.stdout.write(clear.format(''))
    sys.stdout.write('\r{}'.format(msg))
    sys.stdout.flush()

def exit(msg=None, retcode=0):
    if msg is not None:
        stdout(msg)
    sys.exit(0)

def die(msg=None):
    exit(msg, 255)

def getLogger(name, level=logging.INFO, stdout=True):
    global _loggers
    if not os.path.exists(_log_dir):
        os.makedirs(_log_dir)
    if _loggers.get(name, None):
        return _loggers.get(name)
    log_file = os.path.join(_log_dir, '{}.log'.format(name))
    logger = logging.getLogger(name)
    logger.setLevel(logging.DEBUG)
    file_handler = logging.FileHandler(log_file)
    logging_formatter = logging.Formatter('%(asctime)s: %(message)s [%(levelname)s]')
    file_handler.setFormatter(logging_formatter)
    logger.addHandler(file_handler)
    if stdout:
        stdout_handle = logging.StreamHandler(sys.stdout)
        stdout_handle.setFormatter(logging.Formatter('%(message)s'))
        logger.addHandler(stdout_handle)
    _loggers.update({name:logger})
    return logger

def loadYAML(doc):
    if not isinstance(doc, basestring):
        raise TypeError('MUST BE string')
    if os.path.isfile(doc):
        with open(doc, 'r') as fp:
            return yaml.load(fp)
    return yaml.loadYAML(doc)