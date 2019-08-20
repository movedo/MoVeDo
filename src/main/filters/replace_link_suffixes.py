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

import re
#import argparse
import sys
import panflute as pf

# constants
REGEX_URL = re.compile(r'^(?:[a-z:_-]+)://', re.IGNORECASE)
REGEX_ABS_PATH = re.compile(r'^([A-Z]:)?[/\\]', re.IGNORECASE)

# parameters
relative_only = True
ext_from = '.md'
ext_to = '.html'

def is_url(str):
    """Returns True if the argument is a URL."""
    return re.match(REGEX_URL, str) is not None

def is_abs_path(str):
    """Returns True if the argument is an absolute, local file path."""
    return re.match(REGEX_ABS_PATH, str) is not None

def is_rel_path(str):
    """Returns True if the argument is an absolute, local file path."""
    return not (is_url(str) or is_abs_path(str))

"""
parser = argparse.ArgumentParser(description='Pandoc filter that replaces the file extension in (local) links in Markdown files.')
parser.add_argument('-f', '--from-extension', dest='ext_from',
                    default='.md',
                    help='The extension to search for; to convert from')
parser.add_argument('-t', '--to-extension', dest='ext_to',
                    default='.html',
                    help='The extension to convert to')

args = parser.parse_args()
"""

def prepare(doc):
    """The panflute filter init method."""
    relative_only = doc.get_metadata('rls_relative_only', "<rls_relative_only>")
    ext_from = doc.get_metadata('rls_ext_from', "<rls_ext_from>")
    ext_to = doc.get_metadata('rls_ext_to', "<rls_ext_to>")

def action(elem, doc):
    if isinstance(elem, pf.Link) and elem.url.endswith(ext_from) and (not relative_only or is_rel_path(elem.url)):
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
    return pf.run_filter(action,
            prepare=prepare,
            finalize=finalize,
            doc=doc)

if __name__ == '__main__':
    main()
