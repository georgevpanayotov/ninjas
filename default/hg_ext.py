from mercurial.templatefuncs import templatefunc
from mercurial.templateutil import evalstring
from mercurial.templateutil import evalinteger

@templatefunc(
    b"firstlines(subject, line_count=3)",
    argspec=b'subject line_count',
    requires={},
)
def firstlines(context, mapping, args):
    subject = evalstring(context, mapping, args[b"subject"])

    line_count = 3
    if b"line_count" in args:
      line_count = evalinteger(context, mapping, args[b"line_count"])

    lines = subject.split(b"\n")
    return b"\n".join(lines[:line_count])
