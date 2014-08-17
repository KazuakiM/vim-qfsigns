#vim-qfsigns

This Vim plugin is plugin supporting [watchdogs](https://github.com/osyo-manga/vim-watchdogs).  
If [watchdogs](https://github.com/osyo-manga/vim-watchdogs) check syntax error, this plugin mark syntax error lines.

##Requirement

* [vimproc](https://github.com/Shougo/vimproc)
* [vim-quickrun](https://github.com/thinca/vim-quickrun)
* [shabadou.vim](https://github.com/osyo-manga/shabadou.vim)
* [watchdogs](https://github.com/osyo-manga/vim-watchdogs)

##Installation
###Sample setting.

Sample setting is using [NeoBundle](https://github.com/Shougo/neobundle.vim).  
This setting is not working. However it's plugins setting hint.  
Please check Requirement plugins's READE.md. thanx :)

```vim
NeoBundle 'Shougo/vimproc'
NeoBundle 'thinca/vim-quickrun'
let g:quickrun_config = {
\    'watchdogs_checker/_' : {
\        'hook/qfsigns_update/enable_exit':   1,
\        'hook/qfsigns_update/priority_exit': 3,},}
NeoBundle 'osyo-manga/shabadou.vim'
NeoBundle 'osyo-manga/vim-watchdogs'
NeoBundle 'KazuakiM/vim-qfsigns'

" If syntax error, cursor is moved at line setting sign.
let g:qfsigns#AutoJump = 1
" If syntax error, view split and cursor is moved at line setting sign.
let g:qfsigns#AutoJump = 2
```

###Usage

sings jump functions supported.

```vim
:QfsignsJunmp
```

##Author

[KazuakiM](https://github.com/KazuakiM/)

##License

This software is released under the MIT License, see LICENSE.
