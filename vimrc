" Environment {

    " Basics {
        set nocompatible " Use Vim settings, rather than Vi settings (much better!)
    " }

    " Setup Bundle Support {
        " The next three lines ensure that the ~/.vim/bundle/ system works
        filetype on     " workaround for macosx
        filetype off    " required
        set rtp+=~/.vim/bundle/vundle
        call vundle#rc()
    " }
" }

" Use bundles config {
    if filereadable(expand("~/.vimrc.bundles"))
        source ~/.vimrc.bundles
    endif
" }

" General {

	set t_Co=256                   " Xterm 256 colors
	set background=dark            " Assume a dark background
	filetype plugin indent on      " Automatically detect file types.
	syntax on                      " Syntax highlighting
	set mouse=a                    " Automatically enable mouse usage
	set mousehide                  " Hide the mouse cursor while typing
	set encoding=utf-8 nobomb      " BOM often causes trouble
	set hidden                     " Allow buffer switching without saving
    set virtualedit=onemore        " Allow for cursor beyond last character
    set history=1000               " Store a ton of history (default is 20)
    " set spell                    " Spell checking on
    " set autowrite                " Automatically write a file when leaving a modified buffer

    " Setting up the directories {
        set nobackup            " Do not keep a backup file, use versions instead.
        if has('persistent_undo')
            set undofile            " So is persistent undo ...
            set undolevels=1000     " Maximum number of changes that can be undone
            set undoreload=10000    " Maximum number lines to save for undo on a buffer reload
        endif

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
    " }
" }

" Vim UI {

    if filereadable(expand("~/.vim/bundle/vim-distinguished/colors/distinguished.vim"))
        colorscheme distinguished   " Load a colorscheme
    endif

    set showmode                    " Display the current mode
    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr   " Remove highlight color from current line number

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        "set statusline+=%{fugitive#statusline()} " Git Hotness
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set bs=indent,eol,start         " Allow backspacing over everything in insert mode
    set linespace=0                 " No extra spaces between rows
    set nu                          " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set magic                       " Enable extended regexes.
    set title                       " Show the filename in the window titlebar.
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    set esckeys                     " Allow cursor keys in insert mode.
    set diffopt=filler              " Add vertical spaces to keep right and left aligned.
    set diffopt+=iwhite             " Ignore whitespace changes (focus on code changes).
" }

" Formatting {

    set nowrap          " Do not wrap lines.
    set autoindent		" Copy indent from last line when starting new line.
    set smartindent		" Know about functions end while intending.
    set expandtab		" Expand tabs to spaces
    set shiftwidth=4	" Control how many columns text is indented with the reindent operations.
    set softtabstop=4	" Control how many columns vim uses when you hit Tab in insert mode.
    set tabstop=4		" Tell vim how many columns a tab counts for.
" }

" Key (re)Mappings {

    " Don't use Ex mode, use Q for formatting
    map Q gq

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

    " Faster split resizing (+,-)
    if bufwinnr(1)
      map + <C-W>+
      map - <C-W>-
    endif

    " Better split switching (Ctrl-j, Ctrl-k, Ctrl-h, Ctrl-l)
    map <C-j> <C-W>j
    map <C-k> <C-W>k
    map <C-H> <C-W>h
    map <C-L> <C-W>l

    " Sudo write (,W)
    noremap <leader>W :w !sudo tee %<CR>

    " Remap :W to :w
    command W w

    " Insert newline
    map <leader><Enter> o<ESC>
" }