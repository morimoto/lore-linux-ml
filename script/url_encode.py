#! /usr/bin/env python3
#===============================
#
# url encode
#
# 2022/02/01 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
#===============================
import urllib.parse
import sys
print(urllib.parse.quote(sys.argv[1]))
