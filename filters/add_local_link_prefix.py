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

import re
import panflute as pf
from bs4 import BeautifulSoup
from _common import is_rel_path

# parameters
# should be something like 'some/static/prefix/'
prefix = '<default-prefix>'

def prefix_if_rel_path(url):
    """
    Prefixes the input URL with the prefix,
    if the URL is a link to/image with a relative path.
    """
    global prefix
    if is_rel_path(url):
        url = prefix + url
    return url

def prefix_elem_if_rel_path(elem):
    """
    Prefixes the URL of an input element with the prefix,
    if the URL is a link to/image with a relative path.
    """
    elem.url = prefix_if_rel_path(elem.url)

def prefix_html(elem):
    """Prepends the reference-formatted relative file path to the identifier."""
    parsed = BeautifulSoup(elem.text, 'html.parser')
    replaced = False
    anchors_with_href = parsed.findAll(
        lambda tag:
        tag.name == "a" and tag.get("href") != None)
    for anchor in anchors_with_href:
        new_href = prefix_if_rel_path(anchor.get("href"))
        if new_href != anchor.get("href"):
            anchor["href"] = new_href
            replaced = True
    imgs_with_src = parsed.findAll(
        lambda tag:
        tag.name == "img" and tag.get("src") != None)
    for img in imgs_with_src:
        new_src = prefix_if_rel_path(img.get("src"))
        if new_src != anchor.get("src"):
            anchor["src"] = new_src
            replaced = True
    if replaced:
        elem.text = str(parsed)
        # HACK Remove end-tag automatically inserted by BeautifulSoup as a sanitation matter, see https://stackoverflow.com/questions/57868615/how-to-disable-the-sanitizer-beautifulsoup
        elem.text = re.sub(r'></[^>]+>$', '>', elem.text)
    #eprint("XXX allp HTML after '%s'" % elem.text)

def prepare(doc):
    """The panflute filter init method."""
    global prefix
    prefix = doc.get_metadata('allp_prefix', "<allp_prefix>")

def action(elem, doc):
    """The panflute filter main method, called once per element."""
    if isinstance(elem, (pf.Link, pf.Image)):
        prefix_elem_if_rel_path(elem)
    if isinstance(elem, pf.RawInline) and elem.format == 'html':
        prefix_html(elem)
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
