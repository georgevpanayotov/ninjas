import vim
import random


class Selection:

    def __init__(self, mode, start, end):
        self.mode = mode
        self.start = start
        self.end = end


def GetVisualSelection():
    lineStart, columnStart = vim.eval("getpos(\"'<\")[1:2]")
    lineEnd, columnEnd = vim.eval("getpos(\"'>\")[1:2]")

    return Selection(
        vim.eval("visualmode()"), (int(lineStart) - 1, int(columnStart) - 1),
        (int(lineEnd) - 1, int(columnEnd) - 1))


def ChangeSelection(changeFunctor):
    selection = GetVisualSelection()

    if selection.mode == "v":
        ChangeVisualSelection(selection, changeFunctor)
    elif selection.mode == "V":
        ChangeVisualLineSelection(selection, changeFunctor)
    elif selection.mode == "":
        ChangeVisualBlockSelection(selection, changeFunctor)

    line, column = selection.start
    # Vim's cursor position is wacky. The line numbers start at 1 and the column
    # numbers start at 0.
    vim.current.window.cursor = (line + 1, column)

# Standard visual mode selection. Goes from start to end following the regular flow of the line.
# Therefore, we only respect the start column on the starting line and the end column on the ending
# line. Every line in between is fully changed.
def ChangeVisualSelection(selection, changeFunctor):
    for lineNumber in range(selection.start[0], selection.end[0] + 1):
        line = vim.current.buffer[lineNumber]
        if lineNumber == selection.start[0]:
            start = selection.start[1]
        else:
            start = 0

        if lineNumber == selection.end[0]:
            end = selection.end[1]
        else:
            end = len(line)

        vim.current.buffer[lineNumber] = ChangeSubString(line, start, end, changeFunctor)

# Visual line selection covers the whole line. Therefore change every line completely.
def ChangeVisualLineSelection(selection, changeFunctor):
    for lineNumber in range(selection.start[0], selection.end[0] + 1):
        vim.current.buffer[lineNumber] = changeFunctor(vim.current.buffer[lineNumber])

# Visual block selection covers a (roughly) rectangular section. Therefore respect the start/end
# columns for each line.
def ChangeVisualBlockSelection(selection, changeFunctor):
    for lineNumber in range(selection.start[0], selection.end[0] + 1):
        line = vim.current.buffer[lineNumber]
        start = selection.start[1]
        end = selection.end[1]

        vim.current.buffer[lineNumber] = ChangeSubString(line, start, end, changeFunctor)

def ChangeSubString(line, start, end, changeFunctor):
    changed = changeFunctor(line[start:end + 1])

    prefix = line[:start]
    suffix = line[end + 1:]

    return prefix + changed + suffix

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

# THis isn'T A prODuCTiVE Use OF yoUR TiMe.
def ChangeToRandomCase():

    def RandomFunctor(original):
        random.seed()
        randomCase = ""
        for c in original:
            if c.isalpha():
                if random.randrange(2) == 0:
                    randomCase = randomCase + c.upper()
                else:
                    randomCase = randomCase + c.lower()
            else:
                randomCase = randomCase + c
        return randomCase

    ChangeSelection(RandomFunctor)
