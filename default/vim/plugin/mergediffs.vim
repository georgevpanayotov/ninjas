if $GIT_EXEC_PATH != ''
  " git mode
  let s:output = 4
  let s:local = 1
  let s:base = 2
  let s:other = 3
else
  " hg mode
  let s:output = 1
  let s:local = 2
  let s:base = 3
  let s:other = 4
endif

function OpenBuf(bufnr)
  execute bufwinnr(a:bufnr) . 'wincmd w'
endfunction

function DiffAll()
  call OpenBuf(s:local)
  diffthis
  call OpenBuf(s:base)
  diffthis
  call OpenBuf(s:other)
  diffthis

  " Jump to output last, the user needs to edit this.
  call OpenBuf(s:output)
  diffthis
endfunction

function DiffLocal()
  " Diff the base against the 'local'. NOTE: for rebase this is really the
  " 'other'.
  call OpenBuf(s:local)
  diffthis
  call OpenBuf(s:base)
  diffthis

  call OpenBuf(s:other)
  diffoff

  " Jump to output last, the user needs to edit this.
  call OpenBuf(s:output)
  diffoff
endfunction

function DiffOther()
  " Diff the base against the 'other'. NOTE: for rebase this is really the
  " 'local'.
  call OpenBuf(s:base)
  diffthis
  call OpenBuf(s:other)
  diffthis

  call OpenBuf(s:local)
  diffoff

  " Jump to output last, the user needs to edit this.
  call OpenBuf(s:output)
  diffoff
endfunction

