syntax on
set nocompatible
set ts=4
set sw=4
set nowrap
set et
set t_vb=
set vb
map <F6> :qa!<ENTER>
set ai
set si
set hls
set ruler
set bs=2
set guioptions-=T
set number

command Braces :%s/^\(\s*\)[^ \t]\+.*\zs\s*{\s*$/\r\1{
