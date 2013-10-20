" ruler.vim
" Author:  Peter Simon <simonpepe@gmail.com>
" Version: 1.0
" License: Same as Vim itself. See :help license

" Initialization {{{

    if &compatible
        echoerr 'ruler.vim won''t work in compatible mode.'
        finish
    endif

    if exists('g:ruler_loaded')
        finish
    endif
    let g:ruler_loaded = 1

    set ruler

" }}}


" Helpers {{{

    function! s:GetEncodingForRuler()
        let ret = empty(&fileencoding) ? &encoding : &fileencoding
        let ret = toupper(ret)

        if &bomb
            let ret .= '-bom'
        endif

        return ret ==? 'utf-8' ? '' : ret
    endfunction

    function! s:GetFileFormatForRuler()
        return &fileformat ==? 'unix' ? '' : toupper(&fileformat)
    endfunction

    function! s:GetModifiedFlagForRuler()
        if &modified
            return '[+]'
        elseif !&modifiable
            return '[-]'
        else
            return ''
        endif
    endfunction

" }}}


function! GetRuler()
    let rulerParts = [
\       <SID>GetEncodingForRuler(),
\       <SID>GetFileFormatForRuler(),
\       <SID>GetModifiedFlagForRuler()
\   ]

    call filter(rulerParts, '!empty(v:val)')

    return join(rulerParts, ' | ')
endfunction


set rulerformat=%25(%=%{GetRuler()}%)
