#!/bin/sh

# SPDX-FileCopyrightText: 2021 Robin Vobruba <hoijui.quaero@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

this_scripts_dir_rel=`dirname $0`
. "$this_scripts_dir_rel/_common.sh"

cat > "$in_file" << EOF
## URLs

[link-url-abs-1](http://www.google.com/dir/file.md)
[link-url-abs-2](ssh://git@github.com/user/repo/dir/file.md)
[link-url-abs-3](ftp://www.google.com/dir/file.md)
[link-url-abs-4](ftp://user@www.google.com/dir/file.md)
[link-url-abs-5](strange-protocol://user@www.google.com/dir/file.md)
[link-url-abs-6](wierd_protocol://user@www.google.com/dir/file.md)
[link-url-abs-7](double:protocol://user@www.google.com/dir/file.md)
[link-url-abs-8](double::protocol://user@www.google.com/dir/file.md)

[link-url-abs-ref-1](http://www.google.com/dir/file.md#in-page-ref-99)
[link-url-abs-ref-2](ssh://git@github.com/user/repo/dir/file.md#in-page-ref-99)
[link-url-abs-ref-3](ftp://www.google.com/dir/file.md#in-page-ref-99)
[link-url-abs-ref-4](ftp://user@www.google.com/dir/file.md#in-page-ref-99)
[link-url-abs-ref-5](strange-protocol://user@www.google.com/dir/file.md#in-page-ref-99)
[link-url-abs-ref-6](wierd_protocol://user@www.google.com/dir/file.md#in-page-ref-99)
[link-url-abs-ref-7](double:protocol://user@www.google.com/dir/file.md#in-page-ref-99)
[link-url-abs-ref-8](double::protocol://user@www.google.com/dir/file.md#in-page-ref-99)

## Local

### Absolute

[link-url-abs-loc-1](/root/dir/file.md)
[link-url-abs-loc-2](C:/root/dir/file.md)
[link-url-abs-loc-3](D:/root/dir/file.md)
[link-url-abs-loc-4](/root/file.md)
[link-url-abs-loc-5](C:/dir/file.md)
[link-url-abs-loc-6](D:/root/file.md)
[link-url-abs-loc-7](/root/file.md)

[link-url-abs-loc-ref-1](/root/dir/file.md#in-page-ref-99)
[link-url-abs-loc-ref-2](C:/root/dir/file.md#in-page-ref-99)
[link-url-abs-loc-ref-3](D:/root/dir/file.md#in-page-ref-99)
[link-url-abs-loc-ref-4](/root//file.md#in-page-ref-99)
[link-url-abs-loc-ref-5](C:/dir/file.md#in-page-ref-99)
[link-url-abs-loc-ref-6](D:/root/file.md#in-page-ref-99)
[link-url-abs-loc-ref-7](/root/file.md#in-page-ref-99)

### Relative

[link-url-rel-1](some/prefix/relative/dir/file.md)
[link-url-rel-2](some/prefix/relative/dir/file.md)
[link-url-rel-3](some/relative/dir/file.md)
[link-url-rel-5](relative/dir/file.md)
[link-url-rel-6](relative/dir/file.md)
[link-url-rel-7](../relative/dir/file.md)

[link-url-rel-ref-1](some/prefix/relative/dir/file.md#in-page-ref-99)
[link-url-rel-ref-2](some/prefix/relative/dir/file.md#in-page-ref-99)
[link-url-rel-ref-3](some/relative/dir/file.md#in-page-ref-99)
[link-url-rel-ref-5](relative/dir/file.md#in-page-ref-99)
[link-url-rel-ref-6](relative/dir/file.md#in-page-ref-99)
[link-url-rel-ref-7](../relative/dir/file.md#in-page-ref-99)

### Ref Only

[link-url-ref-1](#simple)
[link-url-ref-2](#more-complex-33)
EOF

cat > "$exp_out_file" << EOF
## URLs {#dir-file-urls}

[link-url-abs-1](http://www.google.com/dir/file.md)
[link-url-abs-2](ssh://git@github.com/user/repo/dir/file.md)
[link-url-abs-3](ftp://www.google.com/dir/file.md)
[link-url-abs-4](ftp://user@www.google.com/dir/file.md)
[link-url-abs-5](strange-protocol://user@www.google.com/dir/file.md)
[link-url-abs-6](wierd_protocol://user@www.google.com/dir/file.md)
[link-url-abs-7](double:protocol://user@www.google.com/dir/file.md)
[link-url-abs-8](double::protocol://user@www.google.com/dir/file.md)

[link-url-abs-ref-1](http://www.google.com/dir/file.md#in-page-ref-99)
[link-url-abs-ref-2](ssh://git@github.com/user/repo/dir/file.md#in-page-ref-99)
[link-url-abs-ref-3](ftp://www.google.com/dir/file.md#in-page-ref-99)
[link-url-abs-ref-4](ftp://user@www.google.com/dir/file.md#in-page-ref-99)
[link-url-abs-ref-5](strange-protocol://user@www.google.com/dir/file.md#in-page-ref-99)
[link-url-abs-ref-6](wierd_protocol://user@www.google.com/dir/file.md#in-page-ref-99)
[link-url-abs-ref-7](double:protocol://user@www.google.com/dir/file.md#in-page-ref-99)
[link-url-abs-ref-8](double::protocol://user@www.google.com/dir/file.md#in-page-ref-99)

## Local {#dir-file-local}

### Absolute {#dir-file-absolute}

[link-url-abs-loc-1](/root/dir/file.md)
[link-url-abs-loc-2](C:/root/dir/file.md)
[link-url-abs-loc-3](D:/root/dir/file.md)
[link-url-abs-loc-4](/root/file.md)
[link-url-abs-loc-5](C:/dir/file.md)
[link-url-abs-loc-6](D:/root/file.md)
[link-url-abs-loc-7](/root/file.md)

[link-url-abs-loc-ref-1](/root/dir/file.md#in-page-ref-99)
[link-url-abs-loc-ref-2](C:/root/dir/file.md#in-page-ref-99)
[link-url-abs-loc-ref-3](D:/root/dir/file.md#in-page-ref-99)
[link-url-abs-loc-ref-4](/root//file.md#in-page-ref-99)
[link-url-abs-loc-ref-5](C:/dir/file.md#in-page-ref-99)
[link-url-abs-loc-ref-6](D:/root/file.md#in-page-ref-99)
[link-url-abs-loc-ref-7](/root/file.md#in-page-ref-99)

### Relative {#dir-file-relative}

[link-url-rel-1](#some-prefix-relative-dir-file)
[link-url-rel-2](#some-prefix-relative-dir-file)
[link-url-rel-3](#some-relative-dir-file)
[link-url-rel-5](#relative-dir-file)
[link-url-rel-6](#relative-dir-file)
[link-url-rel-7](#_-relative-dir-file)

[link-url-rel-ref-1](#some-prefix-relative-dir-file-in-page-ref-99)
[link-url-rel-ref-2](#some-prefix-relative-dir-file-in-page-ref-99)
[link-url-rel-ref-3](#some-relative-dir-file-in-page-ref-99)
[link-url-rel-ref-5](#relative-dir-file-in-page-ref-99)
[link-url-rel-ref-6](#relative-dir-file-in-page-ref-99)
[link-url-rel-ref-7](#_-relative-dir-file-in-page-ref-99)

### Ref Only {#dir-file-ref-only}

[link-url-ref-1](#dir-file-simple)
[link-url-ref-2](#dir-file-more-complex-33)
EOF

run_filter "-M ll_doc_path=dir/file.ext"

eval_result

