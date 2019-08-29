# Common SH(/BASH) functions, to be sourced.
#
# This is part of the [MoVeDo](https://github.com/movedo) project.
# See LICENSE.md for copyright information.

# Exit immediately on each error and unset variable;
# see: https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -Eeuo pipefail
set -Eeu

_var_set() {
	set | grep '^'"$1"'=' > /dev/null
}

_set_if_unset() {
	if ! _var_set "$1"
	then
		eval "$1='$2'"
	fi
}

script_dir=$(cd $(dirname $0); pwd)
# Root of the local MoVeDo (doc build tool) root directory
_set_if_unset movedo_root_dir $(cd "$script_dir/.."; pwd)
# Where to look for the Python panflute Pandoc filters
filters_dir="$movedo_root_dir/filters"
# The Projects root dir
_set_if_unset proj_dir $(pwd)
# Root directory for all files created during the documentation build process
_set_if_unset build_dir_rel "build"
_set_if_unset build_dir "$proj_dir/$build_dir_rel"
# YAML meta-data, to be usedin the single, fused Markdown file as FrontMatter
_set_if_unset doc_meta_file "$proj_dir/doc.yml"
# BibTex meta-data, to be usedin the PDF output (optional)
_set_if_unset biblography_file "$proj_dir/citations.bib"
# Root for all generated sources
# the original sources are copied in here too,
# and the documentation is actually built from here
_set_if_unset gen_src_dir "$build_dir/gen_sources"
_set_if_unset html_dir "$build_dir/html"
_set_if_unset pdf_dir "$build_dir/pdf"
_set_if_unset single_md "$build_dir/doc.md"
_set_if_unset single_pdf "$pdf_dir/doc.pdf"

_check_tools() {
	tools="$@"

	for tool in $tools
	do
		if ! which $tool > /dev/null 2>&1
		then
			echo "ERROR: '$tool' is not installed. Please install it manually, or run '`dirname $0`/setup'" 1>&2
			exit 1
		fi
	done
}

_check_env() {

	if [ ! -e "$gen_src_dir" ]
	then
		echo "ERROR: Generated sources dir not found, please run '`dirname $0`/generate'" 1>&2
		exit 1
	fi
}

