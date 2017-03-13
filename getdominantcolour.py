#!/usr/bin/env python3

from colorthief import ColorThief
import sys, colorsys

files = sys.argv[1:]
list = []

# Create list of elements of the type [filename, dominant colours]
for file in files:
    colour_thief = ColorThief(file)
    dominant_colour = colour_thief.get_color(quality=1)
    duo = [file, dominant_colour]
    list.append(duo)

# Sort this list by hue
sorted_by_colour = sorted(list, key=lambda rgb: colorsys.rgb_to_hls(*rgb[1]))

# Now make a list just of the filenames, in sorted order
filenames_only = [item[0] for item in sorted_by_colour]

print(filenames_only)

sys.exit(0)

# ### Testing ###
#
# list = [['./output-jhove-copy/jhove-copy_screencap_01.png', (215, 218, 219)], ['./output-jhove-copy/jhove-copy_screencap_02.png', (215, 218, 219)], ['./output-jhove-copy/jhove-copy_screencap_03.png', (106, 161, 161)], ['./output-jhove-copy/jhove-copy_screencap_04.png', (107, 164, 164)], ['./output-jhove-copy/jhove-copy_screencap_05.png', (105, 159, 159)], ['./output-jhove-copy/jhove-copy_screencap_06.png', (106, 160, 161)]]
#
# # List of only the RGB tuples
# rgbs_only = [item[1] for item in list]
# # RGB tuples sorted by colour (using HLS)
# rgb_sort = sorted(rgbs_only, key=lambda rgb: colorsys.rgb_to_hls(*rgb))
# # Orig list sorted by second elem in each sub-array (naive sort)
# plain_sort = sorted(list, key=lambda x: x[1])
# # Sort orig list on second elems applying colour sort
# full_sort = sorted(list, key=lambda rgb: colorsys.rgb_to_hsv(*rgb[1]))
#
# print("rgbs only \n", rgbs_only, "\n")
# print("rgb sort (HLS) \n", rgb_sort, "\n")
# print("plain sort (reg sort) \n", plain_sort, "\n")
# print("full sort (full list, HLS sort) \n", full_sort, "\n")
