" set nocompatible
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
set scrolloff=3
set showcmd " display incomplete commands
set number
set ruler
set shell=bash " makes RVM work in vim
set backup
set backupdir=/tmp
set directory=/tmp
set backspace=indent,eol,start
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
set winheight=3
set winminheight=3
set winheight=999
set relativenumber

" use ack instead of grep
set grepprg=ack

syntax on
filetype plugin indent on

" turn off Ex mode
nnoremap Q <nop>

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

" filetype overrides
au BufRead,BufNewFile *.cljc setfiletype clojure
au BufRead,BufNewFile *.boot setfiletype clojure
au BufRead,BufNewFile *.edn setfiletype clojure
au BufRead,BufNewFile *.js setfiletype javascript.jsx

" nnoremap <c-i> ?\s\{2,\}<cr>:nohls<cr>wi

" write file with sudo
cmap w!! w !sudo tee > /dev/null %

" mkdir, write file with :W
function! MkdirWrite()
  silent !mkdir -p %:h
  w
  redraw!
endfunction
command! W call MkdirWrite()

let mapleader=","

" quickly reopen most recent file
nnoremap <leader><leader> <c-^>

" clear hls on return
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()

" quickly redraw screen
nnoremap <leader>r :redraw!<cr>

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

function! EmailSplit()
  let current_file = expand('%')
  if     match(current_file, '.html.erb$') != -1
    exec ':vs ' . substitute(current_file, '.html.erb$', '.text.erb', '')
  elseif match(current_file, '.text.erb$') != -1
    exec ':vs ' . substitute(current_file, '.text.erb$', '.html.erb', '')
  endif
endfunction
map <leader>e :call EmailSplit()<cr>

" Open files in same directory as current file (grb)
cnoremap %% <C-R>=expand('%:h').'/'<cr>

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

" Run tests
let g:async_tests_socket = $ASYNC_TESTS_SOCKET
function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo
    let t:test_command = t:grb_test_runner . a:filename
    if len(g:async_tests_socket)
      exec ":silent !echo 'docker exec -it smithers-dev " . t:test_command . "' > " . g:async_tests_socket
      redraw!
    elseif has("nvim")
      exec ":tabe \|:call termopen('" . t:test_command . "')\|:startinsert"
    else
      exec ":!" . t:test_command
    endif
endfunction
function! SetTestFile()
  " Set the spec file that tests will be run for.
  let t:grb_test_file=@%
endfunction
function! SetTestLine(line)
  let t:grb_test_line=a:line
endfunction
function! SetTestRunner(runner)
  let t:grb_test_runner=a:runner
endfunction
function! RunTestFile(...)
  let in_spec_file = (match(expand("%"), '_spec.rb$') != -1)
  let in_feature_file = (match(expand("%"), '.feature$') != -1)
  let in_js_spec_file = (match(expand("%"), '_spec.js$') != -1)
  if a:0
    if in_spec_file || in_feature_file
      call SetTestLine(a:1)
    elseif in_js_spec_file
      call SetTestLine("")
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
  if in_spec_file || in_feature_file || in_js_spec_file
    call SetTestFile()
    if in_spec_file
      call SetTestRunner("bundle exec rspec --color ")
    elseif in_feature_file
      call SetTestRunner("bundle exec cucumber --color ") " hi dan!
    else " in JS spec file
      call SetTestRunner("bundle exec rake spec:javascript")
      let t:grb_test_file=""
    endif
  elseif !(exists("t:grb_test_file") && exists("t:grb_test_runner"))
    return
  end
  call RunTests(t:grb_test_file . command_suffix)
endfunction
function! RunNearestTest()
  let spec_line_number = line('.')
  call RunTestFile(":" . spec_line_number)
endfunction
function! RunCucumber(commandArgs)
  call SetTestRunner("cucumber --color ")
  call RunTests("-p wip")
endfunction
" Run this file
map <leader>t :call RunTestFile()<cr>
" Run only the example under the cursor
map <leader>T :call RunNearestTest()<cr>
" Run all test files
map <leader>a :call RunTests('spec')<cr>
" Run cucumber wip
map <leader>f :call RunCucumber('-p wip')<cr>
" Reset database, then run cucumber wip
map <leader>F :!RAILS_ENV=test rake db:reset > /dev/null\|:call RunCucumber('-p wip')<cr>

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
function! OpenIfExists(...)
  for f in a:000
    if filereadable(expand(f))
      exec ':topleft :split ' . f
      return 0
    endif
  endfor
  echo "File not found"
endfunction
map <leader>gr :call OpenIfExists('config/routes.rb')<cr>
map <leader>gs :call OpenIfExists('db/structure.sql', 'db/schema.rb')<cr>
map <leader>ga :call OpenIfExists('app/controllers/application_controller.rb')<cr>
map <leader>gg :call OpenIfExists('Gemfile')<cr>
map <leader>gv :call OpenIfExists('~/.vimrc')<cr>
map <leader>ge :call OpenIfExists('.env')<cr>

" expand curly braces to a do-end
map <leader>rd ^f{sdolrAend
" pull variable into a let (inline)
map <leader>rli Ilet(:Ea)wr{A }^
" pull variable into a let (yanked to nearest context)
map <leader>rlp Ilet(:Ea)wr{A }^dd?\(context\\|describe\)pv<``
" begin search and replace macro to remove hash-rocket syntax
map <leader>hrf /:\w\+\s\+=>
" replace hash rocket
map <leader>hrr xepWdWbb
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

" " ctrlp
" set wildignore+=*/tmp/*,*\\tmp\\*,*.swp,*.so,*.exe,*.zip,*-meta.xml,*/target/*
" let g:ctrlp_custom_ignore = '\v[\/](\.git|\.hg|\.svn|compiled|log|node_modules|out)$'
" let g:ctrlp_working_path_mode = 'a'
" map <leader>cc :CtrlPClearCache<cr>

" fzf
function! MyFZF()
  let root = system('git rev-parse --show-toplevel')
  if v:shell_error
    :FZF
  else
    :GFiles --exclude-standard --others --cached
  endif
endfunction
nmap <c-p> :call MyFZF()<cr>

" ultisnips
let g:UltiSnipsExpandTrigger="<c-l>"

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" colors
" set t_Co=256 " 256 colors # seems to be causing drawing errors with zsh

" hybrid
" let s:uname = system("echo -n \"$(uname)\"")
" if !v:shell_error && s:uname == "Linux"
"   let g:hybrid_use_Xresources = 1
" endif
" set background=light
" colo hybrid
" execute pathogen#infect()

" base16
" let base16colorspace=256
" let g:airline_theme='base16_default'
" execute pathogen#infect()
" colorscheme base16-default-dark

" nord
let g:nord_italic = 1
let g:nord_italic_comments = 1
execute pathogen#infect()
colorscheme nord

" spec-runner
" map <leader>t <Plug>RunCurrentSpecFile<cr>
" map <leader>T <Plug>RunFocusedSpec<cr>
" function! g:SpecRunner_detect_midje()
"   return match(@%, '_test\.clj$') != -1 && match(readfile(@%), 'midje') != -1
" endfunction
" let g:spec_runner_available_runners = {
"   \   'rspec': 'rspec',
"   \   'midje': 'lein midje',
"   \ }

" show trailing whitespace
:set list listchars=tab:»·,trail:·

" rainbow parentheses, braces, brackets
let g:bold_parentheses = 0
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" vim-markdown-preview
let vim_markdown_preview_github=1
let vim_markdown_preview_browser='firefox'
let vim_markdown_preview_use_xdg_open=1
let vim_markdown_preview_toggle=3

if has("nvim")
  set mouse=
  au TermOpen * tnoremap <Esc> <c-\><c-n>
  au FileType fzf tunmap <Esc>
  " Workaround to this issue: https://github.com/neovim/neovim/issues/1716#issuecomment-454519716
  " 2019-02-21 - this workaround doesn't seem to be implemented yet
  "cmap w!! w :term sudo tee > /dev/null %
endif
