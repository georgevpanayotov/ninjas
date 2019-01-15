#!/usr/bin/python

import sys
import re
import os

SOURCE_LOCATION = os.getenv("HOME") + "/.tedium/"


def tediumInit(sourceFilename):
  vim.vars["ted_cursor"] = 0
  vim.vars["ted_source"] = sourceFilename


def tediumNext():
  if not "ted_cursor" in vim.vars or not "ted_source" in vim.vars:
    raise ValueError()

  tedium = Tedium(vim.vars["ted_source"], vim.vars["ted_cursor"])
  tedium.openNext()
  vim.vars["ted_cursor"] = tedium.cursor


class TediumActions:
  END = 1
  REGEX = 2
  REGEX_END = 3


class TediumEntry:

  def __init__(self, filename, action, data):
    self.filename = filename
    self.action = action
    self.data = data


class Tedium:

  def __init__(self, sourceFilename, cursor):
    self.sourceFilename = sourceFilename
    self.cursor = cursor
    self._load()

  # Opens the file for the next entry. Advances the cursor. Does nothing if it has reached the end.
  def openNext(self):
    if self.cursor >= len(self.entries):
      return False

    entry = self.entries[self.cursor]
    vim.command("e " + entry.filename)
    vim.command("normal gg")
    if entry.action is not None:
      if entry.action == TediumActions.END:
        vim.command("normal G")
      elif entry.action == TediumActions.REGEX:
        vim.command("/" + entry.data)
      elif entry.action == TediumActions.REGEX_END:
        vim.command("/" + entry.data)

        # Necessary otherwise we don't catch the '{' on the same line as the previous regex.
        vim.command("normal k")
        vim.command("/{$")
        vim.command("normal %")

    self.cursor += 1
    return True

  # Loads and parses the instructions from the file. Set the cursor to start with the first entry.
  def _load(self):
    self.entries = []
    self._loadFile(self.sourceFilename)

  def _loadFile(self, sourceFilename):
    sourceFilename = SOURCE_LOCATION + "/" + sourceFilename + ".ted"
    # import should recursively call _loadFile.
    # Empty lines and comments are skipped
    # Any other line should be ^filename:(action)?$
    sourceFile = open(sourceFilename)
    for line in sourceFile:
      line = line.strip()
      if self._isEmpty(line):
        continue

      importFilename = self._getImportFilename(line)

      if importFilename is not None:
        self._loadFile(importFilename)
        continue

      entryFilename = self._getEntryFilename(line)
      if entryFilename is None:
        raise ValueError()

      action, data = self._getEntryAction(line)

      self.entries.append(TediumEntry(entryFilename, action, data))

  # Return false if the line is empty or a comment.
  def _isEmpty(self, line):
    if len(line) == 0:
      return True

    commentMatch = re.search("^#", line)
    if commentMatch:
      return True

    return False

  # Returns the filename to import or None if it isn't an import line.
  def _getImportFilename(self, line):
    importMatch = re.search("^import (.*)$", line)
    if not importMatch:
      return None

    importFilename = importMatch.group(1)
    if len(importFilename) == 0:
      raise ValueError()

    return importFilename

  # Returns the filename from this entry. Throws if this isn't a valid entry line.
  def _getEntryFilename(self, line):
    entryMatch = re.search("^(.*):(.*)$", line)
    if not entryMatch:
      raise ValueError()

    entryFilename = entryMatch.group(1)
    if len(entryFilename) == 0:
      raise ValueError()

    return entryFilename

  # Returns the action from this entry. Returns None if there isn't an action. Throws if this isn't
  # a valid entry line.
  def _getEntryAction(self, line):
    entryMatch = re.search("^(.*):(.*)$", line)
    if not entryMatch:
      raise ValueError()

    actionString = entryMatch.group(2)
    if len(actionString) == 0:
      return None, None

    # Where action, if present, is one of $,/re/},/re/
    if actionString == "$":
      return TediumActions.END, None
    elif actionString[0] == "/":
      secondSlash = actionString.find("/", 1)
      if secondSlash < 0:
        raise ValueError()

      if secondSlash == len(actionString) - 1:
        return TediumActions.REGEX, actionString[1:-1]
      elif secondSlash == len(actionString) - 2 and actionString[-1] == "}":
        return TediumActions.REGEX_END, actionString[1:-2]
      else:
        raise ValueError()
