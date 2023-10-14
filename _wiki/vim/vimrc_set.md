---
layout  : wiki
title   : vimrc set, keymap
summary : vimrc set
date    : 2023-03-01 21:21:30 +0900
updated : 2023-10-14 10:12:48 +0900
tag     : vimrc set
toc     : true
public  : true
parent  : [[/vim]] 
latex   : false
---
* TOC
{:toc}

# keymap
```viml

## 커서 이동

| key | 설명                 | 응용                     |
|-----|----------------------|--------------------------|
| h   | 왼쪽으로 커서 이동   | 10h : 왼쪽으로 10칸 이동 |
| j   | 아래로 커서 이동     | 10j : 아래로 10줄 이동   |
| k   | 위로 커서 이동       |                          |
| l   | 오른쪽으로 커서 이동 |                          |


```

# VIM 설정
```viml
call plug#begin('~/.vim/plugged')
  Plug 'preservim/nerdtree'
	Plug 'frazrepo/vim-rainbow'
	"python code style rule
	Plug 'nvie/vim-flake8'
	"indent level 줄로 표시
	Plug 'nathanaelkane/vim-indent-guides'
	"yank로 복사한 부분 highlight
	Plug 'machakann/vim-highlightedyank'
	"search할 때 단어 총 개수, 해당 단어가 몇번째 단어인지 표기
	Plug 'osyo-manga/vim-anzu'
	"Plug 'yuttie/comfortable-motion.vim'
	"커서가 놓인 단어에 밑줄
	Plug 'itchyny/vim-cursorword'
	"문자열 끝 공백 붉은색 표시 및 삭제
	Plug 'bitc/vim-bad-whitespace'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'preservim/nerdcommenter'
	Plug 'tpope/vim-surround'
	Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
	Plug 'mhinz/vim-startify'
	Plug 'ycm-core/YouCompleteMe'
  " Track the engine.
  Plug 'SirVer/ultisnips'

  " Snippets are separated from the engine. Add this if you want them:
  Plug 'honza/vim-snippets'
call plug#end()

" 로컬 리더 키 설정은 취향이니 각자 마음에 드는 키로 설정한다
let maplocalleader = "\\"

"1번 위키(공개용)
let g:vimwiki_list = [
    \{
    \   'path': '~/codingmatemoon.github.io/_wiki',
    \   'ext' : '.md',
    \   'diary_rel_path': '.',
    \}
\]

" vimwiki의 conceallevel 을 끄는 쪽이 좋다
let g:vimwiki_conceallevel = 0
"let g:startify_custom_header = ['Welcome to Vim!']
let g:startify_custom_footer = ['Press <leader> n to create a new file', 'Press <leader> b to add a bookmark']
let g:startify_files_number = 10
let g:startify_bookmarks = [
  \ {'w': '~/CodingMateMoon.github.io/_wiki/index.md'},
  \ {'v': '~/.vimrc'},
  \ {'h': '~/.hammerspoon/init.lua'},
  \]

let g:startify_lists = [
  \ { 'type': 'sessions',  'header': ['   Saved sessions'] },
  \ { 'header': ['  Bookmarks'],  'type': 'bookmarks' },
  \ { 'header': ['  MRU'],  'type': 'files' },
  \ { 'header': ['  MRU'. getcwd()],  'type': 'dir' },
  \ ]

" delete vimwiki ignore in YouCompleteMe blacklist
let g:ycm_filetype_blacklist = {}


" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

function! LastModified()
    if g:md_modify_disabled
        return
    endif
    if &modified
        " echo('markdown updated time modified')
        let save_cursor = getpos(".")
        let n = min([10, line("$")])
        keepjumps exe '1,' . n . 's#^\(.\{,10}updated\s*: \).*#\1' .
            \ strftime('%Y-%m-%d %H:%M:%S +0900') . '#e'
        call histdel('search', -1)
        call setpos('.', save_cursor)
    endif
endfun

function! NewTemplate()

    let l:wiki_directory = v:false

    for wiki in g:vimwiki_list
        if expand('%:p:h') =~ expand(wiki.path)
            let l:wiki_directory = v:true
            break
        endif
    endfor

    if !l:wiki_directory
        return
    endif

    if line("$") > 1
        return
    endif

    let l:template = []
    call add(l:template, '---')
    call add(l:template, 'layout  : wiki')
    call add(l:template, 'title   : ')
    call add(l:template, 'summary : ')
    call add(l:template, 'date    : ' . strftime('%Y-%m-%d %H:%M:%S +0900'))
    call add(l:template, 'updated : ' . strftime('%Y-%m-%d %H:%M:%S +0900'))
    call add(l:template, 'tag     : ')
    call add(l:template, 'toc     : true')
    call add(l:template, 'public  : true')
    call add(l:template, 'parent  : ')
    call add(l:template, 'latex   : false')
    call add(l:template, 'resource: ' . substitute(system("uuidgen"), '\n', '', ''))
    call add(l:template, '---')
    call add(l:template, '* TOC')
    call add(l:template, '{:toc}')
    call add(l:template, '')
    call add(l:template, '# ')
    call setline(1, l:template)
    execute 'normal! G'
    execute 'normal! $'

    echom 'new wiki page has created'
endfunction

augroup vimwikiauto
    autocmd BufWritePre *wiki/*.md call LastModified()
    autocmd BufRead,BufNewFile *wiki/*.md call NewTemplate()
augroup END
"autocmd BufWritePre *.md call LastModified()
"autocmd BufRead,BufNewFile *.md call NewTemplate()

" 자주 사용하는 vimwiki 명령어에 단축키를 취향대로 매핑해둔다
command! WikiIndex :VimwikiIndex
nmap <LocalLeader>ww <Plug>VimwikiIndex
nmap <LocalLeader>wi <Plug>VimwikiDiaryIndex
nmap <LocalLeader>w<LocalLeader>w <Plug>VimwikiMakeDiaryNote
nmap <LocalLeader>wt :VimwikiTable<CR>

" F4 키를 누르면 커서가 놓인 단어를 위키에서 검색한다.
nnoremap <F4> :execute "VWS /" . expand("<cword>") . "/" <Bar> :lopen<CR>

" Shift F4 키를 누르면 현재 문서를 링크한 모든 문서를 검색한다
nnoremap <S-F4> :execute "VWB" <Bar> :lopen<CR>
" let g:vimwiki_global_ext = 0

nmap <F7> :NERDTreeToggle<CR>

"nnoremap <LocalLeader>t :Startify<CR>
nmap <c-n> :Startify<cr>
"map <LocalLeader>t <ESC><ESC>:Startify<CR>

" Vimwiki의 테이블 단축키를 사용하지 않도록 한다
let g:vimwiki_table_mappings = 0

augroup vimwikiauto
    " <C-s> 로 테이블에서 오른쪽 컬럼으로 이동한다.
    autocmd FileType vimwiki inoremap <C-s> <C-r>=vimwiki#tbl#kbd_tab()<CR>
    " <C-a> 로 테이블에서 왼쪽 컬럼으로 이동한다.
    autocmd FileType vimwiki inoremap <C-a> <Left><C-r>=vimwiki#tbl#kbd_shift_tab()<CR>
augroup END

" `SPC l s` - save current session
nnoremap <leader>ls :SSave<CR>

" `SPC l l` - list sessions / switch to different project
nnoremap <leader>ll :SClose<CR>
nnoremap <leader>lh :h startify<CR>

set history=500
" Show current position at bottom-right
set ruler

set lazyredraw

set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" Show line number
"set number

" Set line number relative
"set relativenumber


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Search Setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Ignore case when searching
set ignorecase

" Be smart when searching
set smartcase

" Highlight search last result
set hlsearch

" Move cursor when searching
set incsearch


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Color Setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Syntax Enable
syntax on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Indent Setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" tab == 2 space
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Using tab like 2 space
set expandtab
set smarttab

" Auto Indent
set ai
" Smart Indent
set si
set relativenumber!

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Key Mapping
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ,vi =>  Show edit tab .vimrc
nnoremap <leader>vi :tabe ~/.vimrc<CR>

" ,src => Reload .vimrc
nnoremap <leader>src :source ~/.vimrc<CR>

" ,q => Quit
map <leader>q <ESC><ESC>:q<CR>

" F2 => Save File
"imap <F2> <ESC><ESC>:w<CR>
map <F2> <ESC><ESC>:w<CR>

" F3 => Toggle line number
map <F3> <ESC>:set nu! relativenumber!<CR>

" jk => esc, Escape insert mode
inoremap jk <ESC>
```  
