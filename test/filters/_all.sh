#!/bin/sh

# SPDX-FileCopyrightText: 2021 Robin Vobruba <hoijui.quaero@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e

this_scripts_dir_rel=`dirname $0`

for test_script in "$this_scripts_dir_rel/"*.sh
do
	if `echo "$test_script" | xargs basename | grep -q -e '^_' -v`
	then
		echo
		echo "$test_script"
		$test_script
	fi
done

echo
echo "All filter-tests ran successfully!"

