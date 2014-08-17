if &cp || (exists('g:loaded_qfsigns') && g:loaded_qfsigns)
    finish
endif
let g:loaded_qfsigns = 1

command! -nargs=0 QfsignsUpdate :call qfsigns#Qfsigns(0)
command! -nargs=0 QfsignsClear  :call qfsigns#Qfsigns(1)
command! -nargs=0 QfsignsJunmp  :call qfsigns#Jump()
command! -nargs=0 QfsingsJunmp  :call qfsigns#Jump() " I'm typo key. This command is deleted some times. So sorry.
