set nocompatible
set hidden
set history=1000
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set laststatus=2
set showmatch
set incsearch
set hlsearch
set ignorecase smartcase
set cmdheight=2
set switchbuf=useopen
set numberwidth=5
set showtabline=2
set winwidth=79
set scrolloff=3
set showcmd		" display incomplete commands
set number
set ruler
set shell=bash " makes RVM work in vim
set backup
set backupdir=~/.tmp
set directory=~/.tmp
set backspace=indent,eol,start
" use emacs-style tab completion when selecting files, etc  
set wildmode=longest,list
" make tab completion for files/buffers act like bash
set wildmenu
" fix slow O inserts
:set timeout timeoutlen=1000 ttimeoutlen=100
set background=light

syntax on
filetype plugin indent on

" move around splits with <c-hjkl>
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

let mapleader=","

" quickly reopen most recent file
nnoremap <leader><leader> <c-^>

" clear hls on return
function! MapCR()
	nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()

" multipurpose tab key (grb) - indent if at beginning of line, else complete
function! InsertTabWrapper()
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<tab>"
	else
		return "\<c-p>"
	endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" Convenient command to see difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif

" Open files in same directory as current file (grb)
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

" Rename current file (grb)
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

if has("win32")
  " copy to windows clipboard with <leader>y in cygwin
  function! Putclip(type, ...) range
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@
    if a:type == 'n'
      silent exe a:firstline . "," . a:lastline . "y"
    elseif a:type == 'c'
      silent exe a:1 . "," . a:2 . "y"
    else
      silent exe "normal! `<" . a:type . "`>y"
    endif
    call writefile(split(@@,"\n"), '/dev/clipboard')
    let &selection = sel_save
    let @@ = reg_save
  endfunction
  vnoremap <silent> <leader>y :call Putclip(visualmode(), 1)<cr>
  nnoremap <silent> <leader>y :call Putclip('n', 1)<cr>
  " paste from windows clipboard with <leader>p in cygwin
  function! Getclip()
    let reg_save = @@
    let @@ = join(readfile('/dev/clipboard'), "\n")
    setlocal paste
    exe 'normal p'
    setlocal nopaste
    let @@ = reg_save
  endfunction
  nnoremap <silent> <leader>p :call Getclip()<cr>
endif

execute pathogen#infect()

" ctrlp settings
set wildignore+=*/tmp/*,*\\tmp\\*,*.swp,*.so,*.exe,*.zip,*-meta.xml
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

if has("win32")
  let &runtimepath=&runtimepath . ',/cygdrive/c/Users/nwallace/Vim/force.com'
  runtime ftdetect/vim-force.com.vim
  " sfdc settings
  let g:apex_backup_folder="~/.tmp/apex/backup"
  let g:apex_temp_folder="~/.tmp/apex/deploy"
  let g:apex_deployment_error_log="errors.log"
  let g:apex_properties_folder="C:\\Users\\nwallace\\Vim\\properties"
  let g:apex_API_version=27.0
  let g:apex_pollWaitMillis=1000
  let g:apex_syntax_case_sensitive=0
endif
