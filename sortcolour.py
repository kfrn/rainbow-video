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
