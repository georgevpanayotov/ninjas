#!/usr/bin/python3

import sys
import re
import generate_filenames

from functools import cmp_to_key

# TODO: Automate some tests?
# TODO: Options:
#   Omit leading filename/linenumbers and just do one per block.

DEFAULT_COUNT = 3

class Args:
  @staticmethod
  def parse(argv):
    i = 1
    count = DEFAULT_COUNT
    printRanges = False

    while i < len(argv):
      if argv[i] == '-c':
        i = i + 1
        count = int(argv[i])
      elif argv[i] == '-r':
        printRanges = True
      else:
        print("Error: unexpected arg: " + argv[i])
        return None
      i = i + 1

    args = Args()
    args.count = count
    args.printRanges = printRanges

    return args

class InputError(Exception):

  def __init_(self, message):
    self.message = message


class RangeRecord:

  def __init__(self, start, end):
    self.start = start
    self.end = end

  def contains(self, number):
    return number >= self.start and number <= self.end

  def __str__(self):
    return "({}, {})".format(self.start, self.end)


class FileRecord:

  def __init__(self, fileName):
    self.fileName = fileName
    self.ranges = []
    # This is used to make sure we only get line numbers in order.
    self.lastPosition = None

  # Adds a range that is centered around the position.
  def addRange(self, rangeRecord, position):
    if self.lastPosition is not None and self.lastPosition >= position:
      # NOTE: This is not possible anymore because we sort input.
      raise InputError("Line numbers are expected to be in ascending order.")

    self.lastPosition = position

    if len(self.ranges) > 0:
      lastRange = self.ranges[-1]
      if rangeRecord.start - lastRange.end <= 1:
        # If the new range overlaps or is adjancent to the last one, combine them.
        lastRange.end = rangeRecord.end
        rangeRecord = None

    # If not, then just add a new range.
    if rangeRecord is not None:
      self.ranges.append(rangeRecord)

  def print(self, outFile, args):
    if args.printRanges:
      self._printRanges(outFile)
    else:
      self._printContextualLines(outFile)

  def _printRanges(self, outFile):
    outFile.write(self.fileName + "\n")
    for currentRange in self.ranges:
      outFile.write(str(currentRange) + "\n")

  def _printContextualLines(self, outFile):
    if len(self.ranges) == 0:
      return

    rangesIter = enumerate(self.ranges)
    _, currentRange = next(rangesIter)

    fileHandle = open(self.fileName)
    try:
      for lineNumber, line in enumerate(fileHandle, 1):
        if lineNumber > currentRange.end:
          _, currentRange = next(rangesIter)

        if currentRange.contains(lineNumber):
          outFile.write(self.fileName + ":" + str(lineNumber) + ":" + line)

    except StopIteration:
      # This means we've gotten past the last range so nothing more needs to be printed.
      pass
    fileHandle.close()

# Some lines returned by grep don't have a filename, (e.g. "Binary file matches") those lines would
# be "None". Those should sort ahead of any real filenames. This method returns None if both lines
# have filenames (i.e. it defers further sorting to other methods).
def compFileName(leftEntry, rightEntry):
  leftLine, leftFileName, leftNumber = leftEntry
  rightLine, rightFileName, rightNumber = rightEntry

  if leftFileName is None and rightFileName is None:
    return leftLine - rightLine
  elif leftFileName is None:
    return -1
  elif rightFileName is None:
    return 1
  else:
    # Both are real lines so we defer deciding comparison.
    return None

def compEntry(leftEntry, rightEntry):
  leftLine, leftFileName, leftNumber = leftEntry
  rightLine, rightFileName, rightNumber = rightEntry

  comparison = compFileName(leftEntry, rightEntry)

  if comparison is not None:
    return comparison

  # These are both matching lines so we can sort them. First by name then line number.
  if leftFileName < rightFileName:
    return -1
  elif leftFileName > rightFileName:
    return 1
  else:
    return leftNumber - rightNumber


def main(inFile, outFile, args):
  if args is None:
    return

  fileRecord = None
  fileName = None

  for line, newFileName, number in sorted(generate_filenames.fileNames(inFile), key = \
      cmp_to_key(compEntry)):
    if newFileName != fileName:
      if fileRecord is not None:
        fileRecord.print(outFile, args)

      if newFileName is not None:
        fileRecord = FileRecord(newFileName)
      else:
        fileRecord = None

    fileName = newFileName
    if fileRecord is not None:
      fileRecord.addRange(RangeRecord(number - args.count, number + args.count), number)
    else:
      outFile.write(line)

  if fileRecord is not None:
    fileRecord.print(outFile, args)


if __name__ == "__main__":
  main(sys.stdin, sys.stdout, Args.parse(sys.argv))
