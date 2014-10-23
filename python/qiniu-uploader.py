#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys, os
from getopt import getopt
from pprint import pprint

import qiniu.conf
import qiniu.io
import qiniu.rs

_bucket = os.environ.get('QINIU_BUCKET', '')
_access_key = os.environ.get('QINIU_ACCESS_KEY', '')
_secret_key = os.environ.get('QINIU_SECRET_KEY', '')

if not _bucket or not _access_key or not _secret_key:
    exit('config fail')

def upload(filepath, save_name=None, override_if_exists=True):
    qiniu.conf.ACCESS_KEY = _access_key
    qiniu.conf.SECRET_KEY = _secret_key
    if save_name is None:
        save_name = os.path.basename(filepath)
    scope = _bucket
    if override_if_exists:
        scope = '{}:{}'.format(scope, save_name)
    policy = qiniu.rs.PutPolicy(scope)
    uptoken = policy.token()
    return qiniu.io.put_file(uptoken, save_name, filepath)

def usage():
    print('qiniu file uploader.')
    print('')
    print('{} [OPTIONS] FILEPATH'.format(os.path.basename(__file__)))
    print('')
    print(' -h          help message')
    print(' -o          override if exist')
    print(' -s Name     save name')

if __name__ == '__main__':
    try:
        opts, argv = getopt(sys.argv[1:], 'hos:')
    except Exception, e:
        exit('ERROR: argument error.')
    save_name = None
    override_if_exists = False
    for k, v in opts:
        if k == '-h':
            usage()
            sys.exit()
        elif k == '-o':
            override_if_exists = True
        elif k == '-s':
            save_name = v
    if not argv:
        exit('ERROR: file missing.')
    if len(argv) > 1:
        exit('ERROR: only one file at once.')
    filepath = argv[0]
    if not os.path.exists(filepath):
        exit('ERROR: `{}` is non-existent.'.format(filepath))
    ret, err = upload(filepath, save_name, override_if_exists)
    if not ret:
        print('upload fail.')
        exit('ERROR: {}'.format(err))
    url = 'http://{}.qiniudn.com/{}'.format(_bucket, ret['key'])
    print('upload {}: {} => {}'.format('success', filepath, url))
