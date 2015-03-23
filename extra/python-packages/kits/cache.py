# -*- coding: utf-8 -*-
from __future__ import unicode_literals, print_function, absolute_import, division
import os
import json
import time
import codecs

from .util import digest

__all__ = [
    'Cache', 'cache', 'cached', 'DEFAULT_EXPIRE'
]

_cache_dir = os.path.expanduser('~/Library/Caches/net.jeeker.kits')

DEFAULT_EXPIRE = 3600 * 24

class Cache(object):
    def __init__(self, location, autoclean=True):
        self.location = location
        self.autoclean = autoclean
        if not os.path.exists(location):
            os.makedirs(location)
        self._autoclean()

    def _cachepath(self, name):
        return os.path.join(self.location, '{}.json'.format(digest(name)))

    def _content(self, name):
        try:
            with codecs.open(self._cachepath(name), 'r', 'utf-8') as fp:
                return json.load(fp)
        except:
            pass

    def _autoclean(self):
        if not self.autoclean or self.get('kits-python-cacheautocleaned'):
            return
        self.clean()
        self.set('kits-python-cacheautocleaned', True)

    def get(self, name, default=None):
        try:
            data = self._content(name)
            if data and data.get('expires', 0) >= time.time():
                return data.get('data')
        except:
            pass
        self.delete(name)
        return default

    def getall(self):
        data = []
        for f in os.listdir(self.location):
            if not f.endswith('.json'):
                continue
            with codecs.open(os.path.join(self.location, f), 'r', 'utf-8') as fp:
                data.append(json.load(fp))
        return data

    def set(self, name, data, expire=DEFAULT_EXPIRE):
        try:
            data = {
                'expires'   : time.time() + expire,
                'name'          : name,
                'data'          : data
            }
            with codecs.open(self._cachepath(name), 'w', 'utf-8') as fp:
                json.dump(data, fp, indent=4)
        except Exception as e:
            raise e

    def delete(self, name):
        try:
            os.remove(self._cachepath(name))
        except:
            pass

    def expires(self, name):
        data = self._content(name)
        if data and data.get('expires', 0) >= time.time():
            return data.get('expires', 0) - time.time()
        return -1

    def clean(self):
        """Remove all expired caches."""
        to_remove = []
        for f in os.listdir(self.location):
            if not f.endswith('.json'):
                continue
            abspath = os.path.join(self.location, f)
            try:
                with codecs.open(abspath, 'r', 'utf-8') as fp:
                    data = json.load(fp)
                    if data.get('expires', 0) < time.time():
                        to_remove.append(abspath)
            except:
                to_remove.append(abspath)
        for f in to_remove:
            os.remove(f)

    def clear(self):
        """Remove all caches."""
        for f in os.listdir(self.location):
            if not f.endswith('.json'):
                continue
            os.remove(os.path.join(self.location, f))

    # dict interface
    def __getitem__(self, key):
        return self.get(key)

    def __setitem__(self, key, value):
        self.set(key, value)

    def __delitem__(self, key):
        self.delete(key)

    def __contains__(self, key):
        data = self._content(key)
        return data and data.get('expires', 0) >= time.time()

cache = Cache(_cache_dir)

def cached(name, **kw):
    expire = kw.get('expire', DEFAULT_EXPIRE)
    get_check = kw.get('get_check', lambda d: True)
    set_check = kw.get('set_check', lambda d: d is not None)
    def _cached(func):
        def wrapper(*args, **kwargs):
            data = cache.get(name)
            if data is not None and get_check(data):
                return data
            data = func(*args, **kwargs)
            if data is not None and set_check(data):
                cache.set(name, data, expire)
            return data
        return wrapper
    return _cached
