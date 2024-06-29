command Gbuild :call Gbuild()

" Builds the gradle project. If the command fails errors are loaded in the QF buffer.
function Gbuild()
    :!./gradlew build 2> gradle_err.txt
    if v:shell_error == 0
        :cexpr ""
    else
        :cf gradle_err.txt
    endif
endfunction
