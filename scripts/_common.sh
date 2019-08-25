# Common SH(/BASH) functions, to be sourced.
#
# This is part of the [MoVeDo](https://github.com/movedo) project.
# See LICENSE.md for copyright information.

# Exit immediately on each error and unset variable;
# see: https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail

script_dir=$(cd $(dirname $0); pwd)
movedo_root_dir=$(cd "$script_dir/.."; pwd)
filters_dir="$movedo_root_dir/filters"
# The Projects root dir
proj_dir=$(pwd)
build_dir="$proj_dir/build"
gen_src_dir="$build_dir/gen_sources"
html_dir="$build_dir/html"
pdf_dir="$build_dir/pdf"
doc_meta_file="$proj_dir/doc.yml"
single_md="$build_dir/doc.md"
single_pdf="$pdf_dir/doc.pdf"

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

