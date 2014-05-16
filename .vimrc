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
set showcmd " display incomplete commands
set number
set ruler
set shell=bash " makes RVM work in vim
set backup
set backupdir=~/.tmp
set directory=~/.tmp
set backspace=indent,eol,start
set background=light
" open splits to the right and bottom
set splitbelow
set splitright
" use emacs-style tab completion when selecting files, etc
set wildmode=longest,list
" make tab completion for files/buffers act like bash
set wildmenu
" fix slow O inserts
:set timeout timeoutlen=1000 ttimeoutlen=100
" window sizing
set winwidth=84
set winheight=5
set winminheight=5
set winheight=999
set relativenumber

" colors
set t_Co=256 " 256 colors
colo hybrid

syntax on
filetype plugin indent on

" ctrl-s to write file
noremap <silent><c-s> :update<cr>
vnoremap <silent><c-s> <c-c>:update<cr>
inoremap <silent><c-s> <c-o>:update<cr>

" move around splits with <c-hjkl>
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

imap <c-f> <space>=><space>

nnoremap <c-i> ?\s\{2,\}<cr>:nohls<cr>wi

" write file with sudo
cmap w!! w !sudo tee > /dev/null %

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

function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo
    exec ":!bundle exec rspec " . a:filename
endfunction
function! SetTestFile()
  " Set the spec file that tests will be run for.
  let t:grb_test_file=@%
endfunction
function! SetTestLine(line)
  let t:grb_test_line=a:line
endfunction
function! RunTestFile(...)
  let in_spec_file = match(expand("%"), '_spec.rb$') != -1
  if a:0
    if in_spec_file
      call SetTestLine(a:1)
    endif
    if exists("t:grb_test_line")
      let command_suffix = t:grb_test_line
    else
      let command_suffix = ""
    endif
  else
    let command_suffix = ""
  endif
  " Run the tests for the previously-marked file.
  if in_spec_file
    call SetTestFile()
  elseif !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file . command_suffix)
endfunction
function! RunNearestTest()
  let spec_line_number = line('.')
  call RunTestFile(":" . spec_line_number)
endfunction
" Run this file
map <leader>t :call RunTestFile()<cr>
" Run only the example under the cursor
map <leader>T :call RunNearestTest()<cr>
" Run all test files
map <leader>a :call RunTests('spec')<cr>

" visual-mode star search
function! s:VisualStarSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', '\g')
  let @s = temp
endfunction
xnoremap * :<c-u>call <SID>VisualStarSearch('/')<cr>/<c-r>=@/<cr><cr>
xnoremap # :<c-u>call <SID>VisualStarSearch('?')<cr>?<c-r>=@/<cr><cr>

" rails commands
map <leader>gr :topleft :split config/routes.rb<cr>
map <leader>gs :topleft :split db/schema.rb<cr>
map <leader>ga :topleft :split app/controllers/application_controller.rb<cr>
map <leader>gg :topleft 100 :split Gemfile<cr>
map <leader>gv :topleft 100 :split ~/.vimrc<cr>

" expand curly braces to a do-end
map <leader>rd ^f{sdolrAend
" pull variable into a let (inline)
map <leader>rli Ilet(:Ea)wr{A }^
" pull variable into a let (yanked to nearest context)
map <leader>rlp Ilet(:Ea)wr{A }^dd?\(context\\|describe\)pv<``
" begin search and replace macro to remove hash-rocket syntax
map <leader>fhr /:\w\+\s\+=>
" replace hash rocket
map <leader>rhr xepWdWbb
" replace tabs with spaces
map <leader>rt /\t<cr>s  

" blog mode
function! BlogMode()
  :se textwidth=80 linebreak
  " delete all text, then paste it in insert mode (to create wrapping)
  norm! ggVGs"
  " delete extra line that gets added
  norm! Gdd
  :w
endfunction
map <leader>b :call BlogMode()<cr>

" ctrlp
set wildignore+=*/tmp/*,*\\tmp\\*,*.swp,*.so,*.exe,*.zip,*-meta.xml
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
map <leader>cc :CtrlPClearCache<cr>

" ultisnips
let g:UltiSnipsExpandTrigger="<c-l>"

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = "bubblegum"

execute pathogen#infect()

" show trailing whitespace
:highlight ExtraWhitespace ctermbg=gray guibg=gray
:match ExtraWhitespace /\s\+\%#\@<!$/
:au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
:au InsertLeave * match ExtraWhitespace /\s\+$/

" show tabs (use spaces)
:highlight Tabs ctermbg=gray guibg=gray
:match Tabs /\t/
