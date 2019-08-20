"""
This is part of the [MoVeDo](https://github.com/movedo) project.
See LICENSE.md for copyright information.

Adds a prefix to all *local*, *relative* link & image paths,
consisting of the relative path from pwd to the input document.
So for example, if we call `pandoc ... my/input/file.md`,
the paths would be prefixed with 'my/input/'.

It is implemented as a Pandoc filter using panflute.

This might typicaly be used as a preparation step
when combining a multitude of documents found within a directory tree
into a single document at the directory trees root.
Or more pracitcally: when creating a single PDF
out of a bunch of Markdown or HTML files scatered aroudn the filesystem.

Usage example:
$ pandoc -f markdown -t markdown --atx-headers \
        -M allp_prefix="some/static/prefix/" \
        --filter add_local_link_prefix.py \
        -o output.md \
        input.md
"""

from __future__ import print_function

import re
import sys
import panflute as pf

# constants
REGEX_URL = re.compile(r'^(?:[a-z:_-]+)://', re.IGNORECASE)
REGEX_ABS_PATH = re.compile(r'^([A-Z]:)?[/\\]', re.IGNORECASE)

# parameters
# should be something like 'some/static/prefix/'
prefix = 'some/static/prefix/'

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

#def print_elem(elem, doc):
#    eprint('\tid: %s' % elem.identifier)

def prefix_if_rel_path(url):
    """Prefixes an input with a given string, if the input is a relative path."""
    new_url = url
    if is_rel_path(url):
        new_url = prefix + url
    return new_url

def prepare(doc):
    """The panflute filter init method."""
    prefix = doc.get_metadata('allp_prefix', "<allp_prefix>")
    #eprint('\targs: %d' % len(sys.argv))
    #eprint('\tconfig: link_prefix: %s' % link_prefix)
    #eprint('\tconfig: link_prefix: %s' % doc.link_prefix)
    #eprint('\tconfig: link_prefix: %s' % link_prefix)
    #eprint('\tconfig: metadata:   %s' % doc.metadata)
    #for k in doc.metadata:
    #    eprint('\tconfig: metadata 2: %s' % k)
    #doc.metadata.walk(print_elem)
    #for arg in sys.argv:
    #    eprint('\targ="%s"' % arg)

def action(elem, doc):
    """The panflute filter per-element method."""
    if isinstance(elem, (pf.Link, pf.Image)):
        elem.url = prefix_if_rel_path(elem.url)
    return elem

def finalize(doc):
    """The panflute filter "destructor" method."""
    pass

def main(doc=None):
    """
    NOTE: The main function has to be exactly like this
    if we want to be able to run filters automatically
    with '-F panflute'
    """
    return pf.run_filter(action,
            prepare=prepare,
            finalize=finalize,
            doc=doc)

if __name__ == '__main__':
    main()
