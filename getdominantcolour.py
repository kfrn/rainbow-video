#!/usr/bin/env python3

from colorthief import ColorThief
import sys

files = sys.argv[1:]

for file in files:
    colour_thief = ColorThief(file)
    dominant_colour = colour_thief.get_color(quality=1)
    print("filename:", file)
    print("dominant colour:", dominant_colour)

sys.exit(0)
