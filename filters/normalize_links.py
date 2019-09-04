"""
This is part of the [MoVeDo](https://github.com/movedo) project.
See LICENSE.md for copyright information.

Normalize local (absolute and relative) paths in links and images.

Example:

`[l-name](./../some/dir/../some/../more/dirs/../here.txt)`

->

`[l-name](../some/more/here.txt)`

It is implemented as a Pandoc filter using panflute.

This might typicaly be used as an intermediate step
when combining a multitude of documents found within a directory tree
into a single document at the directory trees root.
Or more pracitcally: when creating a single PDF
out of a bunch of Markdown or HTML files scatered aroudn the filesystem.

Usage example:
$ pandoc -f markdown -t markdown --atx-headers \
        --filter normalize_links.py \
        -o output.md \
        input.md
"""

# HACK for panflute on python 2
from __future__ import unicode_literals

import os
import panflute as pf
from _common import is_url

def normalize_url(elem):
    """Normalize the elem.url."""
    if not is_url(elem.url):
        elem.url = os.path.normpath(elem.url)

def prepare(doc):
    """The panflute filter init method."""
    pass

def action(elem, doc):
    """The panflute filter main method, called once per element."""
    if isinstance(elem, (pf.Link, pf.Image)):
        normalize_url(elem)
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
    return pf.run_filter(
        action,
        prepare=prepare,
        finalize=finalize,
        doc=doc)

if __name__ == '__main__':
    main()
