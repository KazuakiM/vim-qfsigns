let s:save_cpo = &cpo
set cpo&vim

let g:qfsigns#default_config = {
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
lockvar! g:qfsigns#default_config

function! Qfsigns#setup()
    let a:qfsigns_config_list = items(extend(exists('g:qfsigns#config') ? copy(qfsigns#config) : {}, g:qfsigns#default_config))
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

