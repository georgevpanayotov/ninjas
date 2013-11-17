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

map <F5> :! ./%<ENTER>


set t_Co=256

color desert
