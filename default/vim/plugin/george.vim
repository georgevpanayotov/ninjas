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


function FormatGP()
    let l:winview = winsaveview()
    norm gg=G
    call winrestview(l:winview)
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
command Itch :vnew|setlocal buftype=nofile|setlocal bufhidden=hide|setlocal noswapfile
command Malkovich :%s/\<[[:alnum:]_]*\>/Malkovich!/g

au FileType objc,objcpp,cpp,proto setlocal equalprg=clang-format\ -style=file\ -assume-filename=%
au FileType cpp call UpdateMatches(80)
au FileType gitcommit,hgcommit call UpdateMatches(72)
au FileType make setlocal noet

au BufRead *.swift set filetype=swift
au BufNewFile *.swift set filetype=swift

set directory=~/.vim/swp//

map \t :FZF<ENTER>


if has('python')
    execute 'pyfile ' . fnamemodify(resolve(expand('<sfile>:p')), ':h') . '/selectv.py'
    map \c :pydo ChangeToCamelCase() <ENTER>
    map \s :pydo ChangeToSnakeCase() <ENTER>
    map \( :pydo WrapWord("(", ")") <ENTER>
    map \{ :pydo WrapWord("{", "}") <ENTER>
    map \[ :pydo WrapWord("[", "]") <ENTER>
    map \" :pydo WrapWord("\"", "\"") <ENTER>
    map \' :pydo WrapWord("'", "'") <ENTER>
    map \< :pydo WrapWord("<", ">") <ENTER>
    map \` :pydo WrapWord("`", "`") <ENTER>

    execute 'pyfile ' . fnamemodify(resolve(expand('<sfile>:p')), ':h') . '/tedium.py'

    function TediumInit(name)
        pydo tediumInit(vim.eval("a:name"))
    endfunction

    command -nargs=1 Tedi :call TediumInit(<f-args>)
    command Ted :pydo tediumNext()
endif
