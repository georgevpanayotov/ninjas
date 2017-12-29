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
set sw=4
set t_Co=256
set t_vb=
set ts=4
set vb
set ignorecase
set laststatus=2
set wildmode=longest,list,full
set wildmenu

" mappings
map <F6> :!echo % >> ~/foo<ENTER>
nnoremap <silent> \\ :nohls<CR>
nnoremap <silent> \= :call FormatGP()<ENTER>
cnoremap \h <C-R>=expand("%:h/")<CR>
cnoremap \f <C-R>=expand("%</")<CR>

set equalprg=clang-format\ -style=file\ -assume-filename=%

function FormatGP()
  let l:winview = winsaveview()
  norm gg=G
  call winrestview(l:winview)
endfunction

" highlighting
" syntax on except for diffs. In the case of diffs,
" often the hightlighting for the diff clashes with the syntax
" and makes things illegible
syntax on
if &diff | syntax off | endif

highlight TabColor ctermbg=green guibg=green ctermfg=black guifg=black
highlight ColorColumn ctermbg=red guibg=red
highlight DiffAdd ctermfg=white guifg=white

au BufNewFile *.java %!~/src/vim_templates/java_template.sh %
au BufNewFile,BufRead *.scala set filetype=scala
set directory=~/.vim/swp//

so `cat ~/.ninjas`/matches.vim
