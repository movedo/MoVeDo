"""
This is part of the [MoVeDo](https://github.com/movedo) project.
See LICENSE.md for copyright information.

This shifts the level of all headers of a document
up or down by a configurable amount.

It is implemented as a Pandoc filter using panflute.

This might typicaly be used to shift all headers of a Markdown file
down by one level, if multiple such files are to be combined into a single one,
each prependet by a top-level header.

Usage example:
$ pandoc -f markdown -t markdown --atx-headers \
        -M sh_shift=1 \
        -M sh_workaround_level_overflow=True \
        -M sh_workaround_level_underflow=False \
        --filter shift_headers.py \
        -o output.md \
        input.md
"""

import panflute as pf
from _common import eprint

# constants
MIN_LEVEL = 1
# NOTE This will be 10 in future pandoc versions (not yet in pandoc 2.7.3)
MAX_LEVEL = 6

# parameters
# shift is usually (+)1, could be -1, but seldomly something else
shift = +1
# if True, instead of an exception when resulting header levels are below MIN_LEVEL,
# we leave it at the original level
workaround_level_overflow = True
# if True, instead of an exception when resulting header levels are above MAX_LEVEL,
# we convert it into an emphazised paragraph
workaround_level_underflow = False

def prepare(doc):
    """The panflute filter init method."""
    shift = doc.get_metadata(
        'sh_shift', "<sh_shift>")
    workaround_level_overflow = doc.get_metadata(
        'sh_workaround_level_overflow', "<sh_workaround_level_overflow>")
    workaround_level_underflow = doc.get_metadata(
        'sh_workaround_level_underflow', "<sh_workaround_level_underflow>")

def action(elem, doc):
    """The panflute filter main method, called once per element."""
    if isinstance(elem, pf.Header):
        level_old = elem.level
        level_new = level_old + shift
        if level_new > MAX_LEVEL:
            eprint(
                "After shifting header levels by %d, '%s' would be on level %d, "
                "which is above the max level %d."
                % (shift, elem.identifier, level_new, MAX_LEVEL))
            if workaround_level_overflow:
                eprint("Thus we convert it to an emphazised text paragraph instead.")
                if level_new == (MAX_LEVEL + 1):
                    elem = pf.Para(pf.Strong(*elem.content))
                else:
                    elem = pf.Para(pf.Emph(*elem.content))
            else:
                raise OverflowError()
        elif level_new < MIN_LEVEL:
            eprint(
                "After shifting header levels by %d, '%s' would be on level %d, "
                "which is below the min level %d."
                % (shift, elem.identifier, level_new, MIN_LEVEL))
            if workaround_level_underflow:
                eprint("Thus we leave it at the min level.")
            else:
                raise OverflowError()
        else:
            elem.level = level_new
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
