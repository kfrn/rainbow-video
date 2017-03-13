#!/usr/bin/env python3

import sys
from slugify import slugify

filename = sys.argv[1]
fixed_filename = slugify(filename)
print(fixed_filename)

sys.exit(0)
