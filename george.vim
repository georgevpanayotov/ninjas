" settings
set nocompatible
set ts=4
set sw=4
set nowrap
set et
set t_vb=
set vb
set ai
set si
set hls
set ruler
set bs=2
set guioptions-=T
set number
set t_Co=256
set backupskip=/tmp/*,/private/tmp/*
set listchars=tab:>:
set list

" mappings
map <F2> :%!xpretty <ENTER>
map <F3> :!chmod +w "%"<ENTER>
map <F5> :!./%<ENTER>
map <F6> :!echo % >> ~/foo<ENTER>
nnoremap <silent> \\ :nohls<CR>

" commands
" put braces on the right line (after the statement ... duh!)
command Braces :%s/^\(\s*\)\S\+.*\zs\s*{\s*$/\r\1{

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

so `cat ~/.ninjas`/matches.vim
