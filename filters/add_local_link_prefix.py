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

# HACK for panflute on python 2
from __future__ import unicode_literals

import panflute as pf
from _common import is_rel_path

# parameters
# should be something like 'some/static/prefix/'
prefix = '<default-prefix>'

def prefix_if_rel_path(elem):
    """
    Prefixes an inputs URL with a given string,
    if the input is a link/image with to a relative path.
    """
    global prefix
    if is_rel_path(elem.url):
        elem.url = prefix + elem.url

def prepare(doc):
    """The panflute filter init method."""
    global prefix
    prefix = doc.get_metadata('allp_prefix', "<allp_prefix>")

def action(elem, doc):
    """The panflute filter main method, called once per element."""
    if isinstance(elem, (pf.Link, pf.Image)):
        prefix_if_rel_path(elem)
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
