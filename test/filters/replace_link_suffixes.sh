#!/bin/sh

# SPDX-FileCopyrightText: 2021 Robin Vobruba <hoijui.quaero@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

this_scripts_dir_rel=`dirname $0`
. "$this_scripts_dir_rel/_common.sh"

cat > "$in_file" << EOF
[l-name](l-target.md)
EOF

cat > "$exp_out_file" << EOF
[l-name](l-target.html)
EOF

run_filter

eval_result

