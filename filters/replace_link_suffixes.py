"""
This is part of the [MoVeDo](https://github.com/movedo) project.
See LICENSE.md for copyright information.

Replaces the file extensions/suffixes of certain links in an input document.

It is implemented as a Pandoc filter using panflute.

This might typicaly be used to convert local links to *.md to *.html
while converting the format from Markdown to HTML,
as to maintain local cross-linking wihtin the used format.

Usage example:
$ pandoc -f markdown -t markdown --atx-headers \
        -M rls_relative_only=True \
        -M rls_ext_from=".md" \
        -M rls_ext_to=".html" \
        --filter replace_link_suffixes.py \
        -o output.md \
        input.md
"""

# HACK for panflute on python 2
from __future__ import unicode_literals

import panflute as pf
from _common import is_rel_path

# parameters
relative_only = True
ext_from = '.md'
ext_to = '.html'

def prepare(doc):
    """The panflute filter init method."""
    relative_only = doc.get_metadata('rls_relative_only', "<rls_relative_only>")
    ext_from = doc.get_metadata('rls_ext_from', "<rls_ext_from>")
    ext_to = doc.get_metadata('rls_ext_to', "<rls_ext_to>")

def action(elem, doc):
    """The panflute filter main method, called once per element."""
    if isinstance(elem, pf.Link) and elem.url.endswith(ext_from) \
            and (not relative_only or is_rel_path(elem.url)):
        elem.url = elem.url[:-len(ext_from)] + ext_to
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

