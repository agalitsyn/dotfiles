" Environment
" ===========
set nocompatible                " Use Vim settings, rather than Vi settings (much better!)

" Setup Bundle Support, next three lines ensure that the ~/.vim/bundle/ works
filetype on                     " workaround for macosx
filetype off                    " required
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" Use bundles config
if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
endif

" General
" =======
set t_Co=256                    " Xterm 256 colors
set background=dark             " Assume a dark background

" Enable syntax highlighting
filetype off
filetype on
filetype plugin on
filetype plugin indent on       " Automatically detect file types
syntax on                       " Syntax highlighting

set mouse=a                     " Automatically enable mouse usage
set mousehide                   " Hide the mouse cursor while typing

set encoding=utf-8 nobomb       " BOM often causes trouble
set hidden                      " Allow buffer switching without saving
set virtualedit=onemore         " Allow for cursor beyond last character

set history=1000                " Store a ton of history (default is 20)
set spell                     " Spell checking on
set autowrite                   " Automatically write a file when leaving a modified buffer

let mapleader=","               " change leader to comma

" Disable backup and swap files - they trigger too many events for file system watchers
set nobackup
set nowritebackup
set noswapfile

" Use versions instead of swaps
if has('persistent_undo')
    set undofile                " So it is persistent undo
    set undolevels=1000         " Maximum number of changes that can be undone
    set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif

" Setting up the directories
if !isdirectory($HOME . '/.vim/backups')
    call mkdir($HOME . '/.vim/backups', 'p')
endif

if !isdirectory($HOME . '/.vim/swaps')
    call mkdir($HOME . '/.vim/swaps', 'p')
endif

if !isdirectory($HOME . '/.vim/undo')
    call mkdir($HOME . '/.vim/undo', 'p')
endif

set backupdir=~/.vim/backups
set directory=~/.vim/swaps
set undodir=~/.vim/undo

" Vim User Inreface
" =================

" Load a colorscheme
if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
    colorscheme solarized
endif

set colorcolumn=80,120          " Highlight columns 80 and 120
highlight ColorColumn ctermbg=233

set noshowmode                  " Not display the current mode (no needed with vim-airline)
set cursorline                  " Highlight current line

highlight clear SignColumn      " SignColumn should match background
highlight clear LineNr          " Current line number row will have same background color in relative mode
highlight clear CursorLineNr    " Remove highlight color from current line number

if has('cmdline_info')
    set ruler                   " Show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    set showcmd                 " Show partial commands in status line and selected characters/lines in visual mode
endif

if has('statusline')
    set laststatus=2

    set statusline=%<%f\                     " Filename
    set statusline+=%w%h%m%r                 " Options
    set statusline+=%{fugitive#statusline()} " Git
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

" Shortcut to rapidly toggle `set list`
nmap <leader>t :set list!<CR>

" Use cool symbols for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬,trail:'

if has("autocmd")
    " Automatic reloading of .vimrc
    autocmd! bufwritepost .vimrc source %

    " Jump to the last position when reopening a file
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif

    " In insert mode, auto turn on absolute numbered lines
    autocmd InsertEnter * :set number
    autocmd InsertLeave * :set relativenumber

    " In insert mode, auto turn on absolute numbered lines
    autocmd InsertEnter * :set number
    autocmd InsertLeave * :set relativenumber

    " Change status line color based on mode
    hi statusline term=reverse ctermfg=0 ctermbg=2
    au InsertEnter * hi statusline term=reverse ctermbg=4 gui=undercurl guisp=Magenta
    au InsertLeave * hi statusline term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse

    " Syntax of these languages is fussy over tabs Vs spaces
    autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab

    " Treat .rss files as XML
    autocmd BufNewFile,BufRead *.rss setfiletype xml

    " Trim trailing white space on save
    autocmd BufWritePre * :%s/\s\+$//e

    " Show trailing whitepace and spaces before a tab
    highlight ExtraWhitespace ctermbg=red guibg=red
    autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/
endif

set bs=indent,eol,start         " Allow backspacing over everything in insert mode
set linespace=0                 " No extra spaces between rows

set number
set relativenumber              " Mix relative and absolute numbers (vim 7.4+)

set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set magic                       " Enable extended regexes

set title                       " Show the filename in the window titlebar

set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current

set esckeys                     " Allow cursor keys in insert mode

set diffopt=filler              " Add vertical spaces to keep right and left aligned
set diffopt+=iwhite             " Ignore whitespace changes (focus on code changes)

set clipboard=unnamed           " make yank copy to the global system clipboard
set pastetoggle=<Leader>p       " Toggle pase nopaste by ,p

set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all

" Formatting
" ==========

set nowrap                      " Don't wrap lines
set fo-=t                       " Don't automatically wrap text when typing
set textwidth=79                " lines longer than 79 columns will be broken

set autoindent                  " Copy indent from last line when starting new line
set smartindent                 " Know about functions end while intending

set shiftwidth=4                " operation >> indents 4 columns; << unindents 4 columns
set tabstop=4                   " an hard TAB displays as 4 columns
set softtabstop=4               " insert/delete 4 spaces when hitting a TAB/BACKSPACE
set expandtab                   " insert spaces when hitting TABs
set shiftround                  " round indent to multiple of 'shiftwidth'

" Key (re)Mappings
" ================

" Center the cursor vertically
nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>

" Easier formatting of paragraphs
vmap Q gq
nmap Q gqap

" CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break
inoremap <C-U> <C-G>u<C-U>

" insert new line without entering insert mode
 map <CR> o<Esc>

" Faster split resizing (+,-)
if bufwinnr(1)
    map + <C-W>+
    map - <C-W>-
endif

" Better split switching (Ctrl-j, Ctrl-k, Ctrl-h, Ctrl-l)
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Tab switching
map <Leader>, <esc>:tabprevious<CR>
map <Leader>. <esc>:tabnext<CR>

" easier moving of code blocks
" Try to go into visual mode (v), thenselect several lines of code here and
" then press ``>`` several times.
vnoremap < <gv
vnoremap > >gv

" Save with sudo
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
command Wq :execute ':silent w !sudo tee % > /dev/null' | :quit!

" Insert newline
map <leader><Enter> o<ESC>

" ,cd to move to file's working directory
nnoremap <Leader>cd :lcd %:h<CR>

" hide search hl with ctrl+l
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

" Functions
" =========

" Toggle line number
function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc

nnoremap <silent> <F2> :call <SID>StripTrailingWhitespaces()<CR>

" Strip Trailing Whitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

nnoremap <silent> <F3> :call <SID>StripTrailingWhitespaces()<CR>

" Fixing the copy & paste madness
vmap <C-y> y:call system("xclip -i -selection clipboard", getreg("\""))<CR>:call system("xclip -i", getreg("\""))<CR>
nmap <C-v> :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p
imap <C-v> <Esc><C-v>a

" If the current buffer has never been saved, it will have no name,
" call the file browser to save it, otherwise just save it.
command -nargs=0 -bar Update if &modified
    \|    if empty(bufname('%'))
    \|        browse confirm write
    \|    else
    \|        confirm write
    \|    endif
    \|endif

" Ctrl-s to save in normal mode
nnoremap <silent> <C-S> :<C-u>Update<CR>

" Ctrl-s to save while in insert mode
inoremap <c-s> <c-o>:Update<CR>

" Plugins
" ===============

" Fugitive
" --------

nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gr :Gread<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>ge :Gedit<CR>
" Mnemonic _i_nteractive
nnoremap <silent> <leader>gi :Git add -p %<CR>
nnoremap <silent> <leader>gg :SignifyToggle<CR>

" Undotree
" --------

nnoremap <F6> :UndotreeToggle<cr>
" If undotree is opened, it is likely one wants to interact with it.
let g:undotree_SetFocusWhenToggle=1

" Nerdtree
" --------

map <F7> <plug>NERDTreeTabsToggle<CR>
map <leader>e :NERDTreeFind<CR>
nmap <leader>nt :NERDTreeFind<CR>

let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0

" ctrlp
" -----
let g:ctrlp_working_path_mode = 'ra'
nnoremap <silent> <D-t> :CtrlP<CR>
nnoremap <silent> <D-r> :CtrlPMRU<CR>
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\.git$\|\.hg$\|\.svn$',
    \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

if executable('ag')
    let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
elseif executable('ack-grep')
    let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
elseif executable('ack')
    let s:ctrlp_fallback = 'ack %s --nocolor -f'
else
    let s:ctrlp_fallback = 'find %s -type f'
endif
let g:ctrlp_user_command = {
    \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \ },
    \ 'fallback': s:ctrlp_fallback
\ }

" CtrlP extensions
let g:ctrlp_extensions = ['funky']

"funky
nnoremap <Leader>fu :CtrlPFunky<Cr>

" PyMode
" ------

" Disable if python support not present
if !has('python')
    let g:pymode = 0
endif

" Ctags
" -----

set tags=./tags;/,~/.vimtags

" Make tags placed in .git/tags file available in all levels of a repository
let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
if gitroot != ''
    let &tags = &tags . ',' . gitroot . '/.git/tags'
endif

" Tagbar
" ------

nmap <F8> :TagbarToggle<CR>

" Smooth Scrollin
" ---------------

noremap <silent> <C-U> :call smooth_scroll#up(&scroll, 20, 2)<CR>
noremap <silent> <C-D> :call smooth_scroll#down(&scroll, 20, 2)<CR>
noremap <silent> <C-B> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <C-F> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

" Hooks
" =====

" Use local vimrc if available
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
