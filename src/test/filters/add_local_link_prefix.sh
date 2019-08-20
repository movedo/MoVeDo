#!/bin/sh

this_scripts_dir_rel=`dirname $0`
. "$this_scripts_dir_rel/_common.sh"

cat > "$in_file" << EOF
# Some header

[link-url-abs-1](http://www.google.com/dir/file.md)
[link-url-abs-2](ssh://git@github.com/user/repo/dir/file.md)
[link-url-abs-3](ftp://www.google.com/dir/file.md)
[link-url-abs-4](ftp://user@www.google.com/dir/file.md)
[link-url-abs-5](strange-protocol://user@www.google.com/dir/file.md)
[link-url-abs-6](wierd_protocol://user@www.google.com/dir/file.md)
[link-url-abs-7](double:protocol://user@www.google.com/dir/file.md)
[link-url-abs-8](double::protocol://user@www.google.com/dir/file.md)

[link-url-abs-loc-1](/root/dir/file.md)
[link-url-abs-loc-2](C:/root/dir/file.md)
[link-url-abs-loc-3](D:\\root\\dir\\file.md)

[link-url-rel-1](./relative/dir/file.md)
[link-url-rel-2](relative/dir/file.md)
[link-url-rel-3](../relative/dir/file.md)
[link-url-rel-5](../../relative/dir/file.md)
[link-url-rel-6](./../../relative/./dir/file.md)
EOF

cat > "$exp_out_file" << EOF
# Some header

[link-url-abs-1](http://www.google.com/dir/file.md)
[link-url-abs-2](ssh://git@github.com/user/repo/dir/file.md)
[link-url-abs-3](ftp://www.google.com/dir/file.md)
[link-url-abs-4](ftp://user@www.google.com/dir/file.md)
[link-url-abs-5](strange-protocol://user@www.google.com/dir/file.md)
[link-url-abs-6](wierd_protocol://user@www.google.com/dir/file.md)
[link-url-abs-7](double:protocol://user@www.google.com/dir/file.md)
[link-url-abs-8](double::protocol://user@www.google.com/dir/file.md)

[link-url-abs-loc-1](/root/dir/file.md)
[link-url-abs-loc-2](C:/root/dir/file.md)
[link-url-abs-loc-3](D:\\root\\dir\\file.md)

[link-url-rel-1](some/static/prefix/./relative/dir/file.md)
[link-url-rel-2](some/static/prefix/relative/dir/file.md)
[link-url-rel-3](some/static/prefix/../relative/dir/file.md)
[link-url-rel-5](some/static/prefix/../../relative/dir/file.md)
[link-url-rel-6](some/static/prefix/./../../relative/./dir/file.md)
EOF

run_filter "-M allp_prefix='cmd/line/supplied/prefix/'"

eval_result

