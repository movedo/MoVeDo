"""
This is part of the [MoVeDo](https://github.com/movedo) project.
See LICENSE.md for copyright information.

Contains common (utility) functions for the MoVeDo Pandoc filters.

This is typicaly used by importing it into panflute filter scripts:
import * from _common
"""

from __future__ import print_function

import re
import sys

# constants
REGEX_URL = re.compile(r'^(?:[a-z:_-]+)://', re.IGNORECASE)
REGEX_ABS_PATH = re.compile(r'^([A-Z]:)?[/\\]', re.IGNORECASE)

def eprint(*args, **kwargs):
    """Prints a message to stderr, just like `print()` does for stdout)."""
    print(*args, file=sys.stderr, **kwargs)

def is_url(str):
    """Returns True if the argument is a URL."""
    return re.match(REGEX_URL, str) is not None

def is_abs_path(str):
    """Returns True if the argument is an absolute, local file path."""
    return re.match(REGEX_ABS_PATH, str) is not None

def is_rel_path(str):
    """Returns True if the argument is an absolute, local file path."""
    return not (is_url(str) or is_abs_path(str))

