#FROM ubuntu:18.04
FROM debian:latest
COPY . /movedo
ENV MVD_HOME="$(pwd)/movedo"

RUN apt-get update

RUN apt-get install -y -qq ruby > /dev/null
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

# HACK: As of 4. August 2020, panflute (1.12.5) does not support latest pandoc (2.10.x),
# so we install the latest compatible version
# Relevant discussions can be found here:
# * https://github.com/manubot/rootstock/pull/354
# * https://github.com/sergiocorreia/panflute/issues/142
RUN export MVD_PANDOC_VERSION=2.9.2.1
RUN "$MVD_HOME/scripts/install_pandoc"
RUN "$MVD_HOME/scripts/install_panflute" --locales
RUN "$MVD_HOME/scripts/install_pp"
#RUN "$MVD_HOME/scripts/install_pdsite"
RUN gem install minima bundler jekyll





#CMD "$MVD_HOME/scripts/build"




