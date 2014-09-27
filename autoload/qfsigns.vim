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

let s:sign_num = 0

function! qfsigns#Qfsigns(clearonly) "{{{
    "variable buffer
    let b:qfsignsErrorFlag = ! exists('b:qfsignsErrorFlag') ? 0 : b:qfsignsErrorFlag
    "Remove signs
    for i in range(s:sign_num)
        execute 'sign unplace '.(get(g:qfsigns#Config,'id')+i).' buffer='.winbufnr(0)
    endfor
    let s:sign_num = 0
    "Only delete signs
    if g:qfsigns#Enabled == 0 || a:clearonly == 1
        return
    endif
    "Setting signs
    let a:bufnr             = bufnr('%')
    let a:qfsignsErrorCheck = 0
    for a:qfrow in getqflist()
        if a:qfrow.bufnr == a:bufnr
            if a:qfrow.lnum > 0
                execute 'sign place '.(get(g:qfsigns#Config,'id')+s:sign_num).' line='.a:qfrow.lnum.' name='.get(g:qfsigns#Config,'name').' buffer='.winbufnr(0)
                let s:sign_num = s:sign_num+1
                let a:qfsignsErrorCheck = 1
            endif
        endif
    endfor
    " Cursor is moved at line setting sign.
    if a:qfsignsErrorCheck == 1
        if g:qfsigns#AutoJump == 1
            QfsignsJunmp
        elseif g:qfsigns#AutoJump == 2
            if b:qfsignsErrorFlag == 0
                split
            endif
            QfsignsJunmp
        endif
        let b:qfsignsErrorFlag = 1
    else
        let b:qfsignsErrorFlag = 0
    endif
endfunction "}}}

function! qfsigns#Jump() "{{{
    if b:qfsignsErrorFlag == 1
        execute 'sign jump '.get(g:qfsigns#Config,'id').' buffer='.winbufnr(0)
    endif
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo

