# SPDX-FileCopyrightText: 2022-2023 Robin Vobruba <hoijui.quaero@gmail.com>
# SPDX-License-Identifier: Unlicense

FROM debian:testing

RUN apt-get update && \
    apt-get install -y -qq \
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
        python3-pip \
        python3-dev \
        python3-yaml \
        python3-bs4 \
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
        > /dev/null && \
    rm -rf /var/lib/apt/lists/*

RUN gem install \
    chef-utils -v 16.6.14
RUN gem install \
    mdl \
    minima \
    bundler \
    jekyll
RUN mdl --version

# Make Python 3 the default, so pandoc will use it to run panflute,
# which required at least Python 3.6
RUN rm -f /usr/bin/python
RUN ln -s /usr/bin/python3 /usr/bin/python

RUN npm install -g \
    diff2html-cli

ENV WORKDIR="/home/user/code"
WORKDIR "$WORKDIR"

ENV MVD_HOME="$WORKDIR/movedo"
ENV PATH="${MVD_HOME}/bin:${PATH}"
COPY . movedo

# Workaround to get tags, until this bug is solved:
# https://gitlab.com/gitlab-org/gitlab-runner/-/issues/25373
# This also fetches the whole history, as apparently GitLab
# does a shallow clone by default on its runners.
RUN cd "$MVD_HOME"; \
	if $(git rev-parse --is-shallow-repository); \
	then \
		git fetch --tags --unshallow; \
	fi; \
	git submodule update --init --recursive; \
	git remote set-url origin "https://github.com/movedo/MoVeDo.git"

# As of August 2021 (pandoc 2.14.2),
# the below mentioned problem was fixed,
# so we resolve to use the latest version again.
RUN "$MVD_HOME/scripts/install_pandoc"
RUN "$MVD_HOME/scripts/install_panflute" --locales --mvd-from-source
# As of 1. June 2021, latest pandoc (2.14.1) had a bug
# where it failed producing PDFs from Markdown if there are SVG files.
# Thus we installed the latest working version,
# and a panflute version compatible with it:
#RUN export MVD_PANDOC_VERSION=2.13; \
#	"$MVD_HOME/scripts/install_pandoc"
#RUN export MVD_PANFLUTE_VERSION=2.1; \
#	"$MVD_HOME/scripts/install_panflute" --locales

RUN "$MVD_HOME/scripts/install_pp"
RUN "$MVD_HOME/scripts/install_pdsite"

RUN "$MVD_HOME/scripts/install_repvar"
RUN "$MVD_HOME/scripts/install_projvar"

# HACK For "shell not found" error when starting the resulting image.
#      See details here:
#      <https://gitlab.com/gitlab-org/gitlab-runner/-/issues/27614#note_517446691>
ENTRYPOINT ["/bin/bash", "-c", "ln -snf /bin/bash /bin/sh && /bin/bash -c $0" ]

LABEL maintainer="Robin Vobruba <hoijui.quaero@gmail.com>"
LABEL version="1.x"
LABEL description="This can be used as a CI base image when generating documents using MoVeDo - \
https://github.com/movedo/MoVeDo/"
