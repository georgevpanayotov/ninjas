import vim

# TODO: Split along word boundaries.
# TODO: Handle multiline/block selection.


class Selection:

  def __init__(self, mode, start, end):
    self.mode = mode
    self.start = start
    self.end = end


def GetVisualSelection():
  lineStart, columnStart = vim.eval("getpos(\"'<\")[1:2]")
  lineEnd, columnEnd = vim.eval("getpos(\"'>\")[1:2]")

  return Selection(
      vim.eval("mode()"), (int(lineStart) - 1, int(columnStart) - 1),
      (int(lineEnd) - 1, int(columnEnd) - 1))


def ChangeSelection(changeFunctor):
  selection = GetVisualSelection()

  if selection.end[0] != selection.start[0]:
    vim.command(
        ":echoerr \"ChangeSelection Only valid for single line selection.\"")
  else:
    lineNumber = selection.end[0]
    line = vim.current.buffer[lineNumber]

    changed = changeFunctor(line[selection.start[1]:selection.end[1] + 1])

    prefix = line[:selection.start[1]]
    suffix = line[selection.end[1] + 1:]

    line = prefix + changed + suffix

    vim.current.buffer[lineNumber] = line
    line, column = selection.start
    # Vim's cursor position is wacky. The line numbers start at 1 and the column
    # numbers start at 0.
    vim.current.window.cursor = (line + 1, column)


def ChangeToCamelCase():

  def CamelFunctor(original):
    camel = ""
    capitalizeNext = False
    for c in original:
      if c != "_":
        if capitalizeNext:
          camel = camel + c.upper()
          capitalizeNext = False
        else:
          camel = camel + c.lower()
      else:
        capitalizeNext = True
    return camel

  ChangeSelection(CamelFunctor)


def ChangeToSnakeCase():

  def SnakeFunctor(original):
    snake = ""
    firstChar = True
    for c in original:
      if c.isupper() and not firstChar:
        snake = snake + "_"
        snake = snake + c.lower()
      else:
        snake = snake + c.lower()
      firstChar = False
    return snake

  ChangeSelection(SnakeFunctor)


def WrapWord(pre, post):

  def WrapFunctor(original):
    return pre + original.strip() + post

  ChangeSelection(WrapFunctor)


# ThIs IsN't A pRoDuCtIvE uSe Of YoUr TiMe.
def ChangeToSpongeBobCase():

  def SpongeBobFunctor(original):
    spongeBob = ""
    count = 0
    for c in original:
      if c.isalpha():
        if count % 2 == 0:
          spongeBob = spongeBob + c.upper()
        else:
          spongeBob = spongeBob + c.lower()
        count = count + 1
      else:
        spongeBob = spongeBob + c
    return spongeBob

  ChangeSelection(SpongeBobFunctor)
