<!--
SPDX-FileCopyrightText: 2021 Robin Vobruba <hoijui.quaero@gmail.com>

SPDX-License-Identifier: CC0-1.0
-->

# MoVeDo - Modular, Versioned Documentation

[![License: GPL v3](
    https://img.shields.io/badge/License-GPLv3-blue.svg)](
    https://www.gnu.org/licenses/gpl-3.0)
[![REUSE status](
    https://api.reuse.software/badge/github.com/movedo/MoVeDo)](
    https://api.reuse.software/info/github.com/movedo/MoVeDo)

(pronounciation of *MoVeDo* is in Italian)

A build tool for your Markdown based, git hosted documentation.
Think of it like `gradle`, `leiningen`, `maven`, `grunt`,
or any other build tool that mainly relies on convention
(over configuration) -- but for your documentation.

By default it:

* supports pre-processing with [PP][PP]
* produces one HTML file per Markdown file
* produces a single, fused Markdown file
* produces a single PDF file
* uses [YAML Front-Matter document meta-data][YFM]
* promotes/suggests/uses [*Pandoc's Markdown*][PANDOC-MD] (a Markdown flavor),
  though it also works well with [CommonMark][COMMON-MARK]
  and [GFM (GitHub's Markdown)][GFM]

[PP]: https://github.com/CDSoft/pp
[YFM]: https://assemble.io/docs/YAML-front-matter.html
[PANDOC-MD]: https://pandoc.org/MANUAL.html#pandocs-markdown
[COMMON-MARK]: https://commonmark.org
[GFM]: https://help.github.com/articles/github-flavored-markdown/)

## Philosophy & Psychology

The main idea behind MoVeDo is:

> Write your documentation in standard Markdown on git;
> nothing more.

Though it also optionally supports pre-processing,
it is discouraged, and it is applied in a way
that makes the output digestible by any (locally executed) tool,
for further processing/generating docs in other formats.

It wants you to not worry about how the documents are post-processed that much,
but rather on using standard formats an idioms.
That way of thinking nudges one to keep it simple,
using only basic Markdown syntax, whenever possible.

This allows anyone working on the docs
to use their preferred tool for editing, previewing
and even post-processing into distributable document formats.
It also allows for easy switching between post-processing tools,
like [pandoc](https://pandoc.org),
[jekyll](https://jekyllrb.com),
[hugo](https://gohugo.io)\*,
[vue.js](https://vuejs.org)\*,
[docsify](https://docsify.js.org/)\*
or whatever tool that supports Markdown as sources;
no additional requirements.

(\*_Not yet supported_)

It might also make one think twice or three times,
before Markdown extensions supported only by this tool or that platform.
If it manages to do only that, it met it's highest goal,
as this leads to more social thinking,
both for fellow co-workers and the community as a whole.

### Why Markdown

> ... oh boy!

Compared to other clear-text, simple markdown formats
like [reText](https://github.com/retext-project/retext)
and [AsciiDoc](https://asciidoc.org):

* + It is "industry" standard for documentation in Open Source software \
  -> many people know it already & there are lots of examples
* + It is supported by a *lot* of tools and platforms
* - There is no *one* standard for it; many non-marginal sub-standards \
  -> compatibility issues

## Use-Case

### Expected Input

A directory structure sketch of a sample project using MoVeDo:

```
/about.md                              # part of the beginning of the docu
/index.md                              # part of multi-file outputs like HTML, but not PDF
/LICENSE.md                            # treated as repo file -> excluded from the docu
/README.md                             # treated as repo file -> excluded from the docu
/chapters/01_intro/01_section1.md      # (Pandoc's) Markdown file, part of the docu
/chapters/01_intro/02_section2.pp.md   # PP pre-processor annotated Markdown file
/chapters/02_action/01_begining.pp.md
/chapters/02_action/02_end.md
/index-md.txt                          # optional; It denotes which *.md files appear in which order
                                       # in single-file outputs like PDF
/movedo/                               # git sub-module linked to this repo
```

One can use an arbitrary directory structure (including a flat one)
for the Markdown sources.
With the exception of a few special files (like `README` and `LICENSE`),
and directories (like `build` and hidden ones (`.*`)),
all `*.md` files are considered sources for the documentation.

### Sample Output

By default, all output is generated in the `build` directory,
and for the above project would look like:

```
/build/gen-src/index-md.txt                       # either copied from the source, or auto-generated
                                                  # from the FS structure of the *.md files
                                                  # (alphabetically, with directories after files).
                                                  # It denotes which *.md files appear in which order
                                                  # in single-file outputs like PDF
/build/gen-src/index.md
/build/gen-src/about.md
/build/gen-src/chapters/01_intro/01_section1.md
/build/gen-src/chapters/01_intro/02_section2.md   # PP pre-processing is done here
/build/gen-src/chapters/01_intro/03_section3.md
/build/gen-src/chapters/02_action/01_begining.md
/build/gen-src/chapters/02_action/02_end.md
/build/gen-src/doc.md                             # all the above Markdown files fused into one
/build/html/index.html
/build/html/chapters/01_intro/01_section1.html
/build/html/chapters/01_intro/02_section2.html
/build/html/chapters/01_intro/03_section3.html
/build/html/chapters/02_action/01_begining.html
/build/html/chapters/02_action/02_end.html
/build/pdf/doc.pdf                                # doc.md converted into a PDF
```

## How to use

In your git repo containing the Markdown sources, add this repo as a sub-module:

```bash
git submodule add https://github.com/movedo/MoVeDo.git movedo
git submodule update --init --recursive # to install MoVeDo submodules
echo "/build/" >> .gitignore # to git ignore the MoVeDo generated files
```

(and then commit this)

other devs will then have to check the sub-module out as well:

```bash
git submodule update --init --recursive
```

or do it right when cloning your repo:

```bash
git clone --recurse-submodules https://github.com/GH_USER/GH_REPO.git
```

from then on, you can use MoVeDo for building your docu like this:

```bash
movedo/scripts/build
```

This would generate output like shown in [Sample Output](#sample-output).

## Directory Structure

The main directories of this repo are:

```
/scripts/        # BASH scripts that may be used by a "client"-project to generate artifacts
/filters/        # Python Panflute Pandoc filters, that act as little helpers
                 # when dealing with multiple Markdown files that are meant to be fused together
                 # into a single document
/test/filters/   # Unit-tests for the filters mentioned above
```

## Running tests

```bash
test/filters/_all.sh
```
