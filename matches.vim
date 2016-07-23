" The default target line width. We will toss in a colorcolumn
let g:default_width = 100

" Updates the matches. Handles changes in width or just turns on matches for starters.
" Passing 0 for width disables matches.
function UpdateMatches(width)
    if exists('w:matches_created')
        if a:width == 0
            :call UnsetMatches()
        elseif a:width != w:width
            :call UnsetMatches()
            :call SetMatches(a:width)
        endif
    else
        :call SetMatches(a:width)
    endif
endfunction

" Assumes that matches are not set. Enables new matches and sets the appropriate variables.
function SetMatches(width)
    let w:matches_created = 1
    let w:width = a:width

    " Keep tabs on the tabs by highlighting them green (in addition to listchars).
    let w:tabMatch = matchadd('TabColor', '\t')
    " Similarly highlight trailing spaces.
    let w:trailingMatch = matchadd('TabColor', '\s\+$')

    " Highlight the width + 1 column (only for lines that reach that far) helps to keep us within
    " the column limits.
    let w:colorColumnMatch = matchadd('ColorColumn', '\%' . (w:width + 1) . 'v')
endfunction

" Assumes that matches are set. Disables them and removes the variables.
function UnsetMatches()
    :call matchdelete(w:tabMatch)
    :call matchdelete(w:trailingMatch)
    :call matchdelete(w:colorColumnMatch)

    unlet w:matches_created
    unlet w:width
    unlet w:tabMatch
    unlet w:trailingMatch
    unlet w:colorColumnMatch
endfunction

" Automatically enables matching for each window.
au WinEnter * if exists('w:width') | :call UpdateMatches(w:width) | else | :call UpdateMatches(g:default_width) | endif

" Bootstrap us on the first window.
call UpdateMatches(g:default_width)

" Quick shortcuts to change between 80 width, 100 width, or not limit.
nnoremap <silent> \8 :call UpdateMatches(80) <CR>
nnoremap <silent> \1 :call UpdateMatches(100) <CR>
nnoremap <silent> \0 :call UpdateMatches(0) <CR>
