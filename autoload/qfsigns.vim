let s:save_cpo = &cpo
set cpo&vim

let g:qfsigns#Enabled = ! exists('g:qfsigns#Enabled') ? 1 : g:qfsigns#Enabled

function! qfsigns#Setup() "{{{
    let g:qfsigns#Config = [
    \    {
    \        'id'    : '5050',
    \        'name'  : 'QFError',
    \        'icon'  : '',
    \        'linehl': 'SpellBad',
    \        'text'  : 'E>',
    \        'texthl': 'SpellBad',},
    \    {
    \        'id'    : '5051',
    \        'name'  : 'QFWarning',
    \        'icon'  : '',
    \        'linehl': 'SpellLocal',
    \        'text'  : 'W>',
    \        'texthl': 'SpellLocal',},
    \    {
    \        'id'    : '5052',
    \        'name'  : 'QFInfo',
    \        'icon'  : '',
    \        'linehl': 'SpellRare',
    \        'text'  : 'I>',
    \        'texthl': 'SpellRare',},]
    lockvar! g:qfsigns#Config
    for a:qfsigns_config_row in g:qfsigns#Config
        let a:sign_dfine_string = 'sign define '.get(a:qfsigns_config_row,'name')
        \    .' linehl='.get(a:qfsigns_config_row,'linehl')
        \    .' texthl='.get(a:qfsigns_config_row,'texthl')
        if(get(a:qfsigns_config_row,'icon') !=# '')
            let a:sign_dfine_string = a:sign_dfine_string.' icon='.get(a:qfsigns_config_row,'icon')
        else
            let a:sign_dfine_string = a:sign_dfine_string.' text='.get(a:qfsigns_config_row,'text')
        endif
        "PP a:sign_dfine_string
        execute a:sign_dfine_string
    endfor
    unlet a:qfsigns_config_row
endfunction "}}}

function! qfsigns#Qfsigns(clearonly) "{{{
    "Setup
    if !exists('g:qfsigns#Config')
        call qfsigns#Setup()
    endif
    "Remove signs
    for a:qfsigns_config_row in g:qfsigns#Config
        execute 'sign unplace '.get(a:qfsigns_config_row,'id').' file='.expand('%:p')
    endfor
    unlet a:qfsigns_config_row
    "Only delete signs
    if g:qfsigns#Enabled == 0 || a:clearonly == 1
        return
    endif
    "Setting signs
    let a:bufnr = bufnr('%')
    for a:qfrow in getqflist()
        if a:qfrow.bufnr == a:bufnr
            let a:qfsigns_config_key = 'QFError'
            if a:qfrow.type == 'I' || a:qfrow.type == 'info'
                let a:qfsigns_config_key = 'QFWarning'
            elseif a:qfrow.type == 'W' || a:qfrow.type == 'warning'
                let a:qfsigns_config_key = 'QFInfo'
            endif
            if a:qfrow.lnum > 0
                for a:qfsigns_config_row in g:qfsigns#Config
                    if get(a:qfsigns_config_row,'name') ==# a:qfsigns_config_key
                        "PP a:qfsigns_config_row
                        execute 'sign place '.get(a:qfsigns_config_row,'id')
                        \    .' line='.a:qfrow.lnum
                        \    .' name='.get(a:qfsigns_config_row,'name')
                        \    .' file='.expand('%:p')
                    endif
                endfor
                unlet a:qfsigns_config_row
            endif
        endif
    endfor
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo

