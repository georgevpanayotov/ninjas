#!/usr/bin/python3

import sys
import re
import generate_filenames


def main(inFile, outFile):
  fileName = None
  hasPrinted = False

  for line, newFileName, number in generate_filenames.fileNames(inFile):
    if newFileName != fileName and hasPrinted:
      outFile.write("\n")

    fileName = newFileName
    outFile.write(line)
    hasPrinted = True


if __name__ == "__main__":
  main(sys.stdin, sys.stdout)
