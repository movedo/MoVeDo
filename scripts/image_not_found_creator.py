#!/usr/bin/env python3

# SPDX-FileCopyrightText: 2021 Robin Vobruba <hoijui.quaero@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""
Tools to help create indications
that image to be displayed
was not found.
"""

import svgwrite

def create_img_not_found_image(path_text, img_path):
    """
    Creates an SVG image that indicates
    that the original image to be displayed
    was not found.
    """
    dwg = svgwrite.Drawing(img_path, profile='tiny')

    # draw background color
    dwg.add(dwg.rect(insert=(0, 0), size=('110%', '110%'),
                     rx=None, ry=None, fill='rgb(200,200,200)'))

    # draw red cross
    dwg.add(dwg.line((0, 0), (10, 30), stroke=svgwrite.rgb(100, 0, 0, '%')))
    dwg.add(dwg.line((10, 0), (0, 30), stroke=svgwrite.rgb(100, 0, 0, '%')))

    # draw text lines
    dwg.add(dwg.text('Image not found:', insert=(12, 10), fill='black'))
    dwg.add(dwg.text('"%s"' % path_text, insert=(12, 24), fill='black'))

    dwg.save()

# Example call
create_img_not_found_image('example/path.png', 'output_example.svg')
