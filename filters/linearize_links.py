"""
This is part of the [MoVeDo](https://github.com/movedo) project.
See LICENSE.md for copyright information.

Converts all *local*, *relative* link & image paths
to pure ref-style links, and does the same with the references.

It is implemented as a Pandoc filter using panflute.

This might typicaly be used as an intermediary step
when combining a multitude of documents found within a directory tree
into a single document at the directory trees root.
Or more pracitcally: when creating a single PDF
out of a bunch of Markdown or HTML files scatered aroudn the filesystem.

Usage example:
$ pandoc -f markdown -t markdown --atx-headers \
        -M ll_doc_path="dir/to/current.md" \
        --filter linearize_links.py \
        -o output.md \
        input.md
"""

# HACK for panflute on python 2
from __future__ import unicode_literals

import re
import panflute as pf
from _common import is_rel_path

# constants
REGEX_REF_DELETER = re.compile(r'#.*$')
REGEX_PATH_DELETER = re.compile(r'^.*#')
REGEX_SUFFIX = re.compile(r'\.[^.]*$')
REGEX_BACK_REF = re.compile(r'(\.\./)')
REGEX_NON_REF = re.compile(r'[^a-z0-9_-]')

# parameters
# relative path to the document currently being processed
doc_path = '<DEFAULT_DOC_PATH>'
id_prefix = '<DEFAULT_ID_PREFIX>'

# globals
#id_elems = {}

def linearize_link_path(link_path):
    """
    Converts a path+reference string to a reference only.
    Examples:
    * dir/file.md#some-ref -> dir-file-some-ref
    * dir/file.md -> dir-file
    * #some-ref -> some-ref
    """
    global id_prefix
    path = re.sub(REGEX_REF_DELETER, '', link_path)
    ref = re.sub(REGEX_PATH_DELETER, '', link_path)
    if ref == link_path:
        ref = None
    if path == '':
        path = id_prefix
    else:
        path = path.lower()
        path = re.sub(REGEX_SUFFIX, '', path)
        path = re.sub(REGEX_BACK_REF, '_/', path)
        path = re.sub(REGEX_NON_REF, '-', path)
    if ref != None:
        path = path + '-' + ref
    return path

def linearize_url(elem):
    """Linearizes a URL if it is a local path."""
    if is_rel_path(elem.url):
        elem.url = '#' + linearize_link_path(elem.url)

def linearize_identifier(elem):
    """Prepends the reference-formatted relative file path to the identifier."""
    global id_prefix
    elem.identifier = id_prefix + (('-' + elem.identifier) if (elem.identifier != '') else '')

def prepare(doc):
    """The panflute filter init method."""
    global doc_path, id_prefix
    doc_path = doc.get_metadata('ll_doc_path', "<ll_doc_path>")
    id_prefix = linearize_link_path(doc_path)

def action(elem, doc):
    """The panflute filter main method, called once per element."""
    if isinstance(elem, pf.Link):
        linearize_url(elem)
    if hasattr(elem, 'identifier') and elem.identifier != '':
        linearize_identifier(elem)
    return elem

def finalize(doc):
    """The panflute filter "destructor" method."""
    pass
"""    global id_elems
    for elem in id_elems:
        eprint('')
        eprint(elem.identifier)
        elem.identifier = id_elems[elem]
        eprint(elem.identifier)"""

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
