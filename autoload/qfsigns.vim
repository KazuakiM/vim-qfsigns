let s:save_cpo = &cpo
set cpo&vim

let g:qfsigns_enabled = ! exists('g:qfsigns_enabled') ? 1 : g:qfsigns_enabled

let g:qfsigns#DefaultConfig = {
\    'qf'  : {
\        'id'    : '5050',
\        'name'  : 'QFError',
\        'icon'  : '',
\        'linehl': 'SpellBad',
\        'text'  : 'E>',
\        'texthl': 'SpellBad',},
\    'qfw' : {
\        'id'    : '5051',
\        'name'  : 'QFWarning',
\        'icon'  : '',
\        'linehl': 'SpellLocal',
\        'text'  : 'W>',
\        'texthl': 'SpellLocal',},
\    'qfi' : {
\        'id'    : '5052',
\        'name'  : 'QFInfo',
\        'icon'  : '',
\        'linehl': 'SpellRare',
\        'text'  : 'I>',
\        'texthl': 'SpellRare',},}
lockvar! g:qfsigns#DefaultConfig

function! qfsigns#Qfsigns(clearonly)
    "Setup
    let a:qfsigns_config_list = qfsigns#Setup()
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

function! qfsigns#Setup()
    let a:qfsigns_config_list = items(extend(exists('g:qfsigns#Config') ? copy(qfsigns#Config) : {}, g:qfsigns#DefaultConfig))
    for a:qfsigns_config_row in a:qfsigns_config_list
        let a:sign_dfine_string = 'sign define '.a:qfsigns_config_row[1]['name']
        \    .' linehl='.a:qfsigns_config_row[1]['linehl']
        \    .' texthl='.a:qfsigns_config_row[1]['texthl']
        if(a:qfsigns_config_row[1]['icon'] !=# '')
            let a:sign_dfine_string = a:sign_dfine_string.' icon='.a:qfsigns_config_row[1]['icon']
        else
            let a:sign_dfine_string = a:sign_dfine_string.' text='.a:qfsigns_config_row[1]['text']
        endif
        "PP a:sign_dfine_string
        execute a:sign_dfine_string
    endfor
    unlet a:qfsigns_config_row
    return a:qfsigns_config_list
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

