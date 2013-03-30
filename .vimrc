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

command Braces :%s/^\(\s*\)[^ \t]\+.*\zs\s*{\s*$/\r\1{
set number

set t_Co=256
hi diffAdd ctermfg=red ctermbg=lightred guifg=red guibg=lightred
hi diffChange ctermfg=black ctermbg=lightred guifg=black guibg=lightred
hi diffText ctermfg=red ctermbg=lightred guifg=red guibg=lightred
hi diffDelete ctermfg=grey ctermbg=white guifg=grey guibg=white
