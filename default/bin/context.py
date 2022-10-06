#!/usr/bin/python3

import sys
import re
import generate_filenames

# TODO: Automate some tests?
# TODO: Options:
#   Omit leading filename/linenumbers and just do one per block.
#   Configure how wide a contextual area.
#   Debug mode that uses printRanges()


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

  def printRanges(self, outFile):
    outFile.write(self.fileName + "\n")
    for currentRange in self.ranges:
      outFile.write(str(currentRange) + "\n")

  def printContextualLines(self, outFile):
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


def sortKey(entry):
  line, newFileName, number = entry
  return newFileName, number

def main(inFile, outFile):
  fileRecord = None
  fileName = None

  for line, newFileName, number in sorted(generate_filenames.fileNames(inFile), key=sortKey):
    if newFileName != fileName:
      if fileRecord is not None:
        fileRecord.printContextualLines(outFile)

      if newFileName is not None:
        fileRecord = FileRecord(newFileName)
      else:
        fileRecord = None

    fileName = newFileName
    if fileRecord is not None:
      # TODO: `3` should be configurable.
      fileRecord.addRange(RangeRecord(number - 3, number + 3), number)
    else:
      outFile.write(line)

  if fileRecord is not None:
    fileRecord.printContextualLines(outFile)


if __name__ == "__main__":
  main(sys.stdin, sys.stdout)
