" settings
set ai
set backupskip=/tmp/*,/private/tmp/*
set bs=2
set et
set guioptions-=T
set hls
set list
set listchars=tab:>:
set nocompatible
set nowrap
set number
set ruler
set si
set nosmarttab
set hidden
set sw=4
set ts=4
set t_Co=256
set t_vb=
set vb
set ignorecase
set laststatus=2
set wildmode=longest,list,full
set wildmenu
set nosol

" mappings
nnoremap <silent> \\ :nohls<CR>
nnoremap <silent> \= :call FormatGP()<ENTER>
cnoremap \h <C-R>=expand("%:h/")<CR>
cnoremap \f <C-R>=expand("%</")<CR>
nnoremap <silent> \n :let @f=expand('%')<CR>


function FormatGP()
    let l:winview = winsaveview()
    norm gg=G
    if v:shell_error != 0
        cf ~/.wf_err
    else
        call winrestview(l:winview)
    endif
endfunction

function GPFilter()
    normal qjq
    g//y J
    v//y J
    normal ggVG"Jpggdd
endfunction

" highlighting
" syntax on except for diffs. In the case of diffs,
" often the hightlighting for the diff clashes with the syntax
" and makes things illegible
syntax on
if &diff | syntax off | endif

highlight TabColor ctermbg=green guibg=green ctermfg=black guifg=black
highlight ColorColumn ctermbg=red guibg=red

command CommentStrip :g/^[^:]*:\d\+\(:\d\+\)\?:\s*\/\//d
" Creates a new window that is a scratch space.
command Itch :vnew|setlocal buftype=nofile|setlocal bufhidden=hide|setlocal noswapfile
" Turns the current window into a scratch space. If this was based on a real file, all of the
" changes to that file will be lost.
command Scratch :setlocal buftype=nofile|setlocal bufhidden=hide|setlocal noswapfile|0file|set noro
command Malkovich :%s/\<[[:alnum:]_]*\>/Malkovich!/g

au FileType objc,objcpp,cpp,proto setlocal equalprg=clang-format\ -style=file\ -assume-filename=%
au FileType kotlin setlocal equalprg=wrap_format.sh\ ktfmt\ --stdin-name=%\ --kotlinlang-style\ -
au FileType java setlocal equalprg=wrap_format.sh\ google-java-format\ -a\ --assume-filename=%\ -
au FileType kotlin setlocal foldmethod=expr
au FileType kotlin setlocal foldexpr=JavaImport(v:lnum)
au FileType cpp call UpdateMatches(80)
au FileType cpp setlocal foldmethod=expr
au FileType cpp setlocal foldexpr=CppImport(v:lnum)
au FileType gitcommit,hgcommit call UpdateMatches(72)
au FileType gitcommit,hgcommit setlocal equalprg=commit_fmt
au FileType make setlocal noet
au FileType java setlocal foldmethod=expr
au FileType java setlocal foldexpr=JavaImport(v:lnum)
au FileType netrw call UpdateNetrwBuffer()

" Workaround to the netrw buffers being listed as '[No Name]'
" See: https://github.com/neovim/neovim/issues/17841
function UpdateNetrwBuffer()
    let l:curdir_bnr = bufnr('^' . b:netrw_curdir . '$')

    " Only do this if the current bufnr isn't the same as the one listed for the dir name.
    if l:curdir_bnr != bufnr('%')
        " This issue happens only when 'hidden' is true. It seems that netrw will create a new
        " buffer to load its browser. However, when opening a directory vim will create an empty
        " buffer with that directory's name. If 'nohidden' then this buffer is deleted as soon as
        " the netrw buffer is created, this allows netrw to rename its buffer to the directory's
        " name. If 'hidden' then the pre-existing empty buffer hangs around and interferes with the
        " attempt to rename the netrw buffer. This fix just deletes the empty buffer and renames the
        " netrw buffer.
        exec bufnr(l:curdir_bnr) . 'bd'
        exec 'file ' . b:netrw_curdir
    endif
endfunction

function JavaImport(lnum)
  if getline(a:lnum)=~"^import" || (getline(a:lnum - 1)=~"^import" && getline(a:lnum + 1)=~"^import" && getline(a:lnum)=~"^s*$")
    return 1
  endif

  return 0
endfunction

function CppImport(lnum)
  if getline(a:lnum)=~"^#include" || (getline(a:lnum - 1)=~"^#include" && getline(a:lnum + 1)=~"^#include" && getline(a:lnum)=~"^s*$")
    return 1
  endif

  return 0
endfunction

au BufRead *.swift set filetype=swift
au BufNewFile *.swift set filetype=swift

set directory=~/.vim/swp//

map \t :FZF<ENTER>

" Update errorformat to support Kotlin compiler errors.
let &errorformat="e: file://%f:%l:%c %m,".&errorformat

" Update errorformat to support typescript compiler errors.
let &errorformat="%f:%l:%c - error TS%n: %m,".&errorformat

" Recongize errors in bazel BUILD files.
let &errorformat="ERROR: %f:%l:%c: %m,".&errorformat

" Recognize errors in Prettier autoformatter
let &errorformat="%E[error] Unable to format file: %f,%Z%m (%l:%c),".&errorformat

if has('python')
    execute 'pyfile ' . fnamemodify(resolve(expand('<sfile>:p')), ':h') . '/selectv.py'
    map \c :py ChangeToCamelCase() <ENTER>
    map \s :py ChangeToSnakeCase() <ENTER>
    map \( :py WrapWord("(", ")") <ENTER>
    map \{ :py WrapWord("{", "}") <ENTER>
    map \[ :py WrapWord("[", "]") <ENTER>
    map \" :py WrapWord("\"", "\"") <ENTER>
    map \' :py WrapWord("'", "'") <ENTER>
    map \< :py WrapWord("<", ">") <ENTER>
    map \` :py WrapWord("`", "`") <ENTER>
elseif has('python3')
    execute 'py3file ' . fnamemodify(resolve(expand('<sfile>:p')), ':h') . '/selectv.py'
    map \c :py3 ChangeToCamelCase() <ENTER>
    map \s :py3 ChangeToSnakeCase() <ENTER>
    map \( :py3 WrapWord("(", ")") <ENTER>
    map \{ :py3 WrapWord("{", "}") <ENTER>
    map \[ :py3 WrapWord("[", "]") <ENTER>
    map \" :py3 WrapWord("\"", "\"") <ENTER>
    map \' :py3 WrapWord("'", "'") <ENTER>
    map \< :py3 WrapWord("<", ">") <ENTER>
    map \` :py3 WrapWord("`", "`") <ENTER>
endif
