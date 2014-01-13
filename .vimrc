set nocompatible
set ts=4
set sw=4
set nowrap
set et
set t_vb=
set vb
set ai
syntax on
set si
set hls
set ruler
set bs=2
set guioptions-=T

command Braces :%s/^\(\s*\)\S\+.*\zs\s*{\s*$/\r\1{
set number

map <F5> :! ./%<ENTER>


set t_Co=256

if &diff | syntax off | endif

set listchars=tab:>:
set list

highlight TabColor ctermbg=green guibg=green ctermfg=black guifg=black
let tabMatch = matchadd('TabColor', '\t')
let trailingMatch = matchadd('TabColor', '\s\+$')

highlight ColorColumn ctermbg=red guibg=red
let colorColumnMatch = matchadd('ColorColumn', '\%101v')
