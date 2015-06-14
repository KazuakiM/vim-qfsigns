let s:save_cpo = &cpo
set cpo&vim

"variable {{{
let g:qfsigns#Enabled   = ! exists('g:qfsigns#Enabled')   ? 1 : g:qfsigns#Enabled
let g:qfsigns#AutoJump  = ! exists('g:qfsigns#AutoJump')  ? 0 : g:qfsigns#AutoJump
if !exists('g:qfsigns#Config')
    let g:qfsigns#Config = {'id': '5050', 'name': 'QFError',}
    execute 'sign define '.get(g:qfsigns#Config,'name').' linehl=SpellBad texthl=SpellBad text=>>'
    lockvar! g:qfsigns#Config
endif
"}}}
function! qfsigns#Qfsigns(clearonly) "{{{
    "variable buffer
    let b:qfsignsErrorIndex = ! exists('b:qfsignsErrorIndex') ? -1 : b:qfsignsErrorIndex
    let b:qfsignsMaxIndex   = ! exists('b:qfsignsMaxIndex')   ? 0  : b:qfsignsMaxIndex
    "Remove signs
    for l:index in range(b:qfsignsMaxIndex)
        execute 'sign unplace '.(get(g:qfsigns#Config,'id') + l:index).' buffer='.winbufnr(0)
    endfor
    let b:qfsignsMaxIndex = 0
    "Only delete signs
    if g:qfsigns#Enabled == 0 || a:clearonly == 1
        return
    endif
    "Setting signs
    let l:bufnr    = bufnr('%')
    let l:errorFnr = []
    for l:qfrow in getqflist()
        if l:qfrow.bufnr ==# l:bufnr && 0 < l:qfrow.lnum && count(l:errorFnr, l:qfrow.lnum) ==# 0
            execute 'sign place '.(get(g:qfsigns#Config,'id') + b:qfsignsMaxIndex).' line='.l:qfrow.lnum.' name='.get(g:qfsigns#Config,'name').' buffer='.winbufnr(0)
            let b:qfsignsMaxIndex += 1
            call add(l:errorFnr, l:qfrow.lnum)
        endif
    endfor
    " Cursor is moved at line setting sign.
    if b:qfsignsMaxIndex > 0
        if g:qfsigns#AutoJump == 1
            let b:qfsignsErrorIndex = 0
            QfsignsJunmp
        elseif g:qfsigns#AutoJump == 2
            if b:qfsignsErrorIndex == -1
                split
            endif
            let b:qfsignsErrorIndex = 0
            QfsignsJunmp
        else
            let b:qfsignsErrorIndex = 0
        endif
    else
        let b:qfsignsErrorIndex = -1
    endif
endfunction "}}}
function! qfsigns#Jump() "{{{
    "variable buffer
    let b:qfsignsErrorIndex = ! exists('b:qfsignsErrorIndex') ? -1 : b:qfsignsErrorIndex
    "jump at signs
    if b:qfsignsErrorIndex >= 0
        execute 'sign jump '.(get(g:qfsigns#Config,'id') + b:qfsignsErrorIndex).' buffer='.winbufnr(0)
        if b:qfsignsErrorIndex < (b:qfsignsMaxIndex -1)
            let b:qfsignsErrorIndex += 1
        else
            let b:qfsignsErrorIndex  = 0
        endif
    endif
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo

