#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Python setup_tools setup.py for goto_http_redirect_server.

Based on sample https://github.com/pypa/sampleproject/blob/master/setup.py
and instructions at
https://packaging.python.org/guides/distributing-packages-using-setuptools/
https://setuptools.readthedocs.io/en/latest/setuptools.html#automatic-script-creation
"""

import os

from setuptools import setup
from goto_http_redirect_server.goto_http_redirect_server import \
    __version__, \
    __author__, \
    __url__, \
    __url_issues__, \
    __doc__

# Get the long description from the README.md file
__here = os.path.abspath(os.path.dirname(__file__))
with open(os.path.join(__here, 'README.md'), encoding='utf-8') as f_:
    long_description = f_.read()

setup(
    name='goto_http_redirect_server',
    version=__version__,
    author=__author__,
    url=__url__,
    description=__doc__.splitlines()[0],
    long_description=long_description,
    long_description_content_type='text/markdown',
    license='Apache License 2.0 (Apache-2.0)',
    install_requires=[
    ],
    setup_requires=['wheel'],
    # see https://pypi.org/classifiers/
    classifiers=[
        'Development Status :: 4 - Beta',
        'Environment :: Console',
        'Operating System :: OS Independent',
        'Natural Language :: English',
        'License :: OSI Approved :: Apache Software License',
        'Programming Language :: Python :: 3.5',
        'Topic :: Internet :: WWW/HTTP :: HTTP Servers'
    ],
    # keywords should match "topics" listed at github project
    keywords='http-server redirect-urls shortcuts shorturl shorturl-services'
             'shorturls url-shortener',
    python_requires='>=3.5.2',
    packages=['goto_http_redirect_server'],
    entry_points={
        'console_scripts': [
            'goto_http_redirect_server=goto_http_redirect_server.goto_http_redirect_server:main',
        ],
    },
    project_urls={  # Optional
        'Source': __url__,
        'Bug Reports': __url_issues__,
    },
)
