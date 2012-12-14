set nocompatible
set ts=4
set sw=4
set nowrap
set et
set t_vb=
set vb
map <F5> :qa!<ENTER>
set ai
syntax on
set si
set hls
set ruler
set bs=2
set guioptions-=T

command Braces :%s/^\(\s*\)[^ \t]\+.*\zs\s*{\s*$/\r\1{
map <F5> :!echo % >> ~/foo<ENTER>
map <F6> :qa!<ENTER>
map <F3> :!chmod +w "%"<ENTER>
set number
