#!/usr/bin/python3

import re


def fileNames(inFile):
  for line in inFile:
    fileMatch = re.search("^([^:]*):(([0-9]*):)?", line)
    if fileMatch:
      number = None
      if fileMatch.group(3):
        number = int(fileMatch.group(3))
      yield line, fileMatch.group(1), number
    else:
      yield line, None, None
