" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
syntax on

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
"if has("autocmd")
"  filetype plugin indent on
"endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden             " Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes)
set tabstop=4
set autoindent

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

filetype on
filetype plugin on
filetype indent on

set nocompatible
set ruler
set showcmd
set nu
set incsearch
set hlsearch

set mousemodel=popup
set hidden
set mousehide

set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

set smartindent

setlocal keywordprg=$HOME/.vim/external/phpmanual.sh
set t_Co=256
set nowrap
colorscheme agalitsyn

fun MapKeyCommand(key, command)
    exec "map " . a:key . " <Esc>:" . a:command . "<cr>"
endfun;

fun MapKeyCommands(key, commands)
    let exec_command = "map " . a:key
    for command in a:commands
        let exec_command = exec_command . " <Esc>:" . command . "<cr>"
    endfor
    exec exec_command
endfun;

fun MapKeyFunction(key, function_name)
    call MapKeyCommand(a:key, 'call ' . a:function_name . '()')
endfun;

fun MapKeyTest(config, suite, case, args)
    exec "map <F5> <Esc>:w<CR><Esc>:!php run/atf.php -f " . a:config . " -s " . a:suite . " -c " . a:case . " -a '" . a:args . "'<CR>"
endfun;

call MapKeyCommand('<F1>', 'NERDTree')
call MapKeyCommand('<F2>', 'MRU')
call MapKeyCommand('<F3>', 'BufExplorer')
call MapKeyCommand('<F4>', 'Tlist')
call MapKeyCommand('<Tab>', 'wincmd w')
call MapKeyCommands('<F5>', ['make', 'copen'])
call MapKeyFunction('<F6>', 'PhpRun')
call MapKeyFunction('<F7>', 'PhpRunArgs')
call MapKeyCommand('<F12>', 'q')
call MapKeyCommand('<S-F12>', 'wq')

let g:svndiff_autoupdate = 1

set wildmenu
set cpo-=<
set wcm=<C-Z>
map <F6> :emenu <C-Z>

amenu Misc.Add\ PHPDoc :call PhpDoc()<CR>
amenu Misc.SVN\ Diff.Previous :call Svndiff("prev")<CR> 
amenu Misc.SVN\ Diff.Next :call Svndiff("next")<CR>
amenu Misc.SVN\ Diff.Clear :call Svndiff("clear")<CR>

imap <Ins> <Esc>li

if filereadable(".vimproject")
  source .vimproject
endif

if filereadable("vimproject")
  source vimproject
endif

" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END
