if exists('g:loaded_qfsigns')
    finish
endif
let g:loaded_qfsigns  = 1
let g:qfsigns_enabled = ! exists('g:qfsigns_enabled') ? 1 : g:qfsigns_enabled

let s:save_cpo = &cpo
set cpo&vim

function! s:Qfsigns(clearonly)
    "Setup
    let a:qfsigns_config_list = Qfsigns#setup()
    "PP a:qfsigns_config_list
    "Remove signs
    for a:qfsigns_config_row in a:qfsigns_config_list
        execute 'sign unplace '.a:qfsigns_config_row[1]['id'].' file='.expand('%:p')
    endfor
    unlet a:qfsigns_config_row
    "Only delete signs
    if g:qfsigns_enabled == 0 || a:clearonly == 1
        return
    endif
    "Setting signs
    let a:bufnr = bufnr('%')
    for a:qfrow in getqflist()
        if a:qfrow.bufnr == a:bufnr
            let a:qfsigns_config_key = 'qf'
            if a:qfrow.type == 'I' || a:qfrow.type == 'info'
                let a:qfsigns_config_key = 'qfw'
            elseif a:qfrow.type == 'W' || a:qfrow.type == 'warning'
                let a:qfsigns_config_key = 'qfi'
            endif
            if a:qfrow.lnum > 0
                for a:qfsigns_config_row in a:qfsigns_config_list
                    if a:qfsigns_config_row[0] ==# a:qfsigns_config_key
                        "PP a:qfsigns_config_row
                        execute 'sign place '.a:qfsigns_config_row[1]['id']
                        \    .' line='.a:qfrow.lnum
                        \    .' name='.a:qfsigns_config_row[1]['name']
                        \    .' file='.expand('%:p')
                    endif
                endfor
                unlet a:qfsigns_config_row
            endif
        endif
    endfor
endfunction

command! -nargs=0 QfsignsUpdate call s:Qfsigns(0)
command! -nargs=0 QfsignsClear  call s:Qfsigns(1)
command! -nargs=0 QfsignsStart let g:qfsigns_enabled = 1 | QfsignsUpdate
command! -nargs=0 QfsignsStop  let g:qfsigns_enabled = 0 | QfsignsClear

augroup Qfsigns
    autocmd!
    autocmd BufWritePost * :QfsignsUpdate
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

