#!/usr/bin/env python3

import html, sys
for line in sys.stdin:
    print(html.unescape(line), end="")
