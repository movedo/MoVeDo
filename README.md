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

[![In cooperation with Open Source Ecology Germany](
    https://raw.githubusercontent.com/osegermany/tiny-files/master/res/media/img/badge-oseg.svg)](
    https://opensourceecology.de)

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
[GFM]: https://help.github.com/articles/github-flavored-markdown/

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
[vuepress (vue.js)](https://vuepress.vuejs.org)\*,
[docsify](https://docsify.js.org/)\*
or whatever tool that supports Markdown as sources;
no additional requirements.

(\*_Not yet supported_)

It might also make one think twice or three times,
before using Markdown extensions supported only by "this tool" or "that platform".
If it manages to do only that, it met its highest goal,
as this leads to more social thinking,
both for fellow co-workers and the community as a whole.

### Why Markdown

> ... oh boy!

Compared to other [lightweight markup formats](
    https://en.wikipedia.org/wiki/Lightweight_markup_language)
like [reText](https://github.com/retext-project/retext)
and [AsciiDoc](https://asciidoc.org):

* **\+** It is "industry" standard for documentation in Open Source software,
  many people know it already and there are lots of examples
* **\+** It is supported by [a *lot* of tools and platforms](
  https://www.markdownguide.org/tools/)
* **\-** many non-marginal, parallel ["flavors"](
  https://github.com/commonmark/commonmark-spec/wiki/markdown-flavors)
  exist, so there is no *one* standard for it \
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

### What you need to know first

MoVeDo does mainly two things:

1. Converting Markdown (tree of files) -> HTML (tree of files)
2. Converting Markdown (tree of files) -> PDF (single, linear file)

The first part (HTML) is almost entirely out-sourced
to a 3rd party tool of your choice,
while the second is mostly MoVeDo code and pandoc.

So apart from choosing MoVeDo,
you should also choose a Markdown to HTML converter.
If you don't, MoVeDo uses plain pandoc,
which will not result in the most pretty results.
To see which Markdown to HTML converters are currently supported by MoVeDo,
run `ls -1 movedo/scripts/make_html_*` from your project root.

As of October 2021, this are:

* [Jekyll](https://jekyllrb.com) -
  Well established (ruby) static site generator (SSG)
* [mdBook](https://github.com/rust-lang/mdBook) - fast SSG (rust)
* [mkDocs](https://www.mkdocs.org) - simple SSG
* [pandoc](https://pandoc.org) - bare-bones document converter
* [pdsite](http://pdsite.org) - very simple, leight-weight SSG (bash)

Please raise an issue if you need support for an other tool,
or make a pull request.

### CI

The easiest way to use MoVeDo
is by putting your Markdown content in a git repo
and running MoVeDo in the CI (build-bot),
e.g. on GitHub or GitLab.

We generate a [MoVeDo Docker image] that ocntains MoVeDo and all of its mandatory dependencies,
plus quite a few optional tools.

You may use it locally, or on CI (recomended).
How see hwo to use it on CI,
see the approppriate of the following two sample projects;
mainly: copy the CI script:

- GitHub.com
  - Project Repo: <https://github.com/osegermany/git-internals-doc>
  - CI script: <https://github.com/osegermany/git-internals-doc/blob/master/.github/workflows/movedo.yml>
  - Generated output
    - HTML: <https://osegermany.github.io/git-internals-doc/html/index.html> -> TODO BAD; Fix it!
    - PDF: <https://osegermany.github.io/git-internals-doc/pdf/doc.pdf>
- GitLab(.com)
  - Project Repo: <https://gitlab.com/OSEGermany/OHS-3105/>
  - CI script: <https://gitlab.com/OSEGermany/OHS-3105/-/blob/ohs/.gitlab-ci.yml>
  - Generated output
    - HTML: <https://osegermany.gitlab.io/OHS-3105/develop/din-spec-3105-1/>
    - PDF: <https://osegermany.gitlab.io/OHS-3105/develop/DIN_SPEC_3105-1.pdf>

### Installation & Setup

If you really want to run MoVeDo locally (alternative: [CI](#ci)),
You will have to install MoVeDo and qutie a few of its dependencies.
This is described in the following section.

#### Base

> **NOTE**
> MoVeDo is only tested on Linux,
> and will definitely not work on Windows.
> It is not likely to work on OSX.

Setup MoVeDo locally:

```bash
# Change to a directory where you wnat MoVeDo to be installed
#cd ~/Applications/
# Get MoVeDo onto your computer
git clone https://github.com/movedo/MoVeDo.git
# Make sure you can execute it
printf 'PATH=$PATH:%s/bin' "$PWD/MoVeDo" >> ~/.profile
source ~/.profile
```

Now you need to install the dependencies.
We only provide instructions for that for Debian(based) systems.
These instructions work as of November 2024.
If they don't check the instructions in the [Dockerfile](Dockerfile),
and if they are the same or they too do not work for you,
please file an issue.

```bash
set -e
apt-get update
apt-get install -y -qq
  ruby \
  ruby-dev \
  # Install basic tools required in the MoVeDo scripts \
  git \
  cpio \
  wget \
  locales \
  # Used for various, pretty, recursive directory listings, in plain text or HTML \
  tree \
  # NOTE We need python-dev to prevent encoding errors when running panflute (why? :/ ) \
  python3 \
  python3-bs4 \
  python3-dev \
  python3-pip \
  python3-setuptools \
  python3-yaml \
  # For PP PlantUML \
  default-jre \
  # For PDF generation through LaTeX (with Pandoc) \
  texlive-latex-base \
  texlive-fonts-recommended \
  texlive-font-utils \
  texlive-latex-extra \
  librsvg2-bin \
  # In case someone wants to use this Static Site Generator \
  mkdocs \
  # Dependencies of some of our more common filters \
  python3-click \
  python3-git \
  python3-svgwrite \
  # Allows to create nice HTML diffs betwen git refs, \
  # more freely (and accurately) then github or gitlab show them \
  # (as of late 2020). \
  npm \
  > /dev/null

gem install \
  chef-utils -v 16.6.14
gem install \
  mdl \
  minima \
  bundler \
  jekyll
npm install -g \
  diff2html-cli

mvd install_pandoc
mvd install_panflute --locales --mvd-from-source
mvd install_pdsite
mvd install_repvar
mvd install_projvar
set +e
```

From now on,
you can use MoVeDo for building your docu like this:

```bash
cd MyMarkdownDocuProject
mvd build
```

This would generate output like shown in [Sample Output](#sample-output)
in a newly created directory caleld `./build/`.

#### Custom HTML generator (optional, recommended)

Basically, you follow the setup instructions for the tool you choose.
In the case of [jekyll](https://jekyllrb.com), for example,
this means that you will end up having at least a `_config.yml` file
in the repo root.
MoVeDo will detect that, and call jekyll to generate the HTML,
after pre-processing the Markdown.

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
