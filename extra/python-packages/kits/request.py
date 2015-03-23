# -*- coding: utf-8 -*-
"""
Simple module to request HTTP

JinnLynn
http://jeeker.net

get(url, **kwargs)
post(url, **kwargs)
download(url, **kwargs)

Request(
    'http://jeeker.net',
    data = {},
    type = 'GET',               # GET POST default:GET
    referer = '',
    user_agent = '',
    cookie = None,              # CookieJar, Cookie.S*Cookie, dict, string
    auth = {'usr':'', 'pwd':''}, # Only Basic Authorization
    debug = False
    )
"""
from __future__ import unicode_literals, print_function, absolute_import, division
import os
import base64
from urllib import ContentTooShortError
from urllib2 import HTTPError, URLError
from urllib import urlencode
from urllib2 import Request as urlRequest
from urllib2 import build_opener
from urllib2 import HTTPHandler, HTTPSHandler, HTTPCookieProcessor
import Cookie
from cookielib import CookieJar
from xml.dom import minidom
import json

__all__ = [
    'get', 'post', 'download', 'Request'
]

DEFAULT_TIMEOUT = 90

def get(url, **kwargs):
    kwargs.update(type='GET')
    return Request(url, **kwargs)

def post(url, **kwargs):
    kwargs.update(type='POST')
    return Request(url, **kwargs)

def download(url, local, **kwargs):
    if not local:
        raise ValueError('local filepath is empty')
    if not os.path.exists(os.path.dirname(local)):
        os.makedirs(os.path.dirname(local))
    req = Request(url, **kwargs)
    read_size = 0
    real_size = int(req.header.get('content-length', 0))
    with open(local, 'wb') as fp:
        while True:
            block = req.response.read(1024*8)
            if not block:
                break
            fp.write(block)
            read_size += len(block)
    if real_size > 0 and read_size < real_size:
        raise ContentTooShortError(
            'retrieval incomplete: got only {} out of {} bytes'.format(read_size, real_size),
            None
        )

class Request(object):
    def __init__(self, url, **kwargs):
        self.request = None
        self.response = None
        self.url = url
        self.code = -1
        self.info = {}
        self.cookie = None
        self.error = None

        self._content = None

        data = kwargs.get('data', None)
        if data:
            if isinstance(data, dict):
                data = urlencode(data)
            if not isinstance(data, basestring):
                raise ValueError('data must be string or dict')

        request_type = kwargs.get('type', 'POST')
        if data and isinstance(request_type, basestring) and request_type.upper() != 'POST':
            url = '{}?{}'.format(url, data)
            data = None # GET data must be None

        self.request = urlRequest(url, data)

        # referer
        referer = kwargs.get('referer', None)
        if referer:
            self.request.add_header('referer', referer)

        # user-agent
        user_agent = kwargs.get('user_agent', None)
        if user_agent:
            self.request.add_header('User-Agent', user_agent)

        # auth
        auth = kwargs.get('auth', None)
        if auth and isinstance(auth, dict) and 'usr' in auth:
            auth_string = base64.b64encode('{}:{}'.format(auth.get('usr', ''),
                                                          auth.get('pwd', '')))
            self.request.add_header('Authorization', 'Basic {}'.format(auth_string))

        # cookie
        cookie = kwargs.get('cookie', None)
        cj = None
        if cookie:
            if not isinstance(cookie, (dict, CookieJar, Cookie.BaseCookie)):
                raise TypeError('cookie MUST BE dict, CookieJar or BaseCookie')
            if isinstance(cookie, CookieJar):
                cj = cookie
            elif isinstance(cookie, dict):
                result = []
                for k, v in cookie.items():
                    result.append('{}={}'.format(k, v))
                cookie = '; '.join(result)
            elif isinstance(cookie, Cookie.BaseCookie):
                cookie = cookie.output(header='')

            if isinstance(cookie, basestring):
                self.request.add_header('Cookie', cookie)
        if cj is None:
            cj = CookieJar()

        #! TODO: proxy


        # build opener
        debuglevel = 1 if kwargs.get('debug', False) else 0
        opener = build_opener(
            HTTPHandler(debuglevel=debuglevel),
            HTTPSHandler(debuglevel=debuglevel),
            HTTPCookieProcessor(cj)
        )

        # timeout
        timeout = kwargs.get('timeout')
        if not isinstance(timeout, int):
            timeout = DEFAULT_TIMEOUT

        try:
            self.response = opener.open(self.request, timeout=timeout)
            self.url = self.response.geturl()
            self.code = self.response.getcode()
            self.header = self.response.info().dict
            self.cookie = cj
        except HTTPError as e:
            self.code = e.code
            self.error = e
        except URLError as e:
            self.code = -1
            self.error = e
        except Exception as e:
            self.code = -1
            self.error = e

    def raise_error(self):
        if self.error:
            raise self.error

    @property
    def success(self):
        return 200 <= self.code < 300

    @property
    def content(self):
        if self._content is None:
            self._content = self.response.read()
        return self._content

    @property
    def xmldom(self):
        return minidom.parseString(self.content)

    @property
    def json(self):
        return json.loads(self.content)
