# SPDX-FileCopyrightText: 2022 Robin Vobruba <hoijui.quaero@gmail.com>
# SPDX-License-Identifier: Unlicense

#FROM ubuntu:18.04
FROM debian:latest

RUN apt-get update

RUN apt-get install -y -qq ruby ruby-dev > /dev/null
RUN gem install chef-utils -v 16.6.14
RUN gem install mdl
RUN mdl --version

# Install basic tools required in the MoVeDo scripts
RUN apt-get install -y -qq git cpio wget > /dev/null
RUN apt-get install -y locales > /dev/null
# NOTE We need python-dev to prevent encoding errors when running panflute (why? :/ )
RUN apt-get install -y -qq python3 python3-pip python3-dev python3-yaml python3-bs4 > /dev/null
# Make Python 3 the default, so pandoc will use it to run panflute,
# which required at least Python 3.6
RUN rm -f /usr/bin/python
RUN ln -s /usr/bin/python3 /usr/bin/python
# For PP PlantUML
RUN apt-get install -y default-jre > /dev/null
RUN apt-get install -y -qq texlive-latex-base texlive-fonts-recommended texlive-latex-extra librsvg2-bin > /dev/null
RUN apt-get install -y -qq mkdocs > /dev/null

RUN gem install minima bundler jekyll

# Used for various, pretty, recursive directory listings, in plain text or HTML
RUN apt-get install -y -qq tree > /dev/null

# Allows to create nice HTML diffs betwen git refs,
# more freely (and accurately) then github or gitlab show them
# (as of late 2020).
RUN apt-get install -y -qq npm > /dev/null
RUN npm install -g diff2html-cli

# Dependencies of some of our more common scripts
RUN pip3 install click gitpython svgwrite

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
RUN "$MVD_HOME/scripts/install_panflute" --locales
# As of 1. June 2021, latest pandoc (2.14.1) had a bug
# where it failed producing PDFs from Markdown if there are SVG files.
# Thus we installed the latest working version,
# and a panflute version compatible with it:
#RUN export MVD_PANDOC_VERSION=2.13; \
#	"$MVD_HOME/scripts/install_pandoc"
#RUN export MVD_PANFLUTE_VERSION=2.1; \
#	"$MVD_HOME/scripts/install_panflute" --locales

RUN "$MVD_HOME/scripts/install_pp"
#RUN "$MVD_HOME/scripts/install_pdsite"

LABEL maintainer="Robin Vobruba <hoijui.quaero@gmail.com>"
LABEL version="1.x"
LABEL description="This can be used as a CI base image when generating documents using MoVeDo - \
https://github.com/movedo/MoVeDo/"

