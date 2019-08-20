#!/bin/sh

this_scripts_dir_rel=`dirname $0`
. "$this_scripts_dir_rel/_common.sh"

cat > "$in_file" << EOF
Not under any header

# Orig Level 1

Pandoc supported header levels go from

## Orig Level 2

min: 1

### Orig Level 3

to

#### Orig Level 4

max: 6

##### Orig Level 5

###### Orig Level 6
EOF

# This addition would make the Markdown file invalid
# Pandoc would cause an erorr while fitlering it.
if false
then
cat >> "$tmp_in_file" << EOF

This next one is one level too deep already in the original.
What will happen with it?


####### Orig Level 7

... and the text inside of it?

EOF
fi

cat > "$exp_out_file" << EOF
Not under any header

## Orig Level 1

Pandoc supported header levels go from

### Orig Level 2

min: 1

#### Orig Level 3

to

##### Orig Level 4

max: 6

###### Orig Level 5

**Orig Level 6**
EOF

run_filter

eval_result

