" Use Vim settings, rather than Vi settings (much better!).
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Set syntax highlighting options.
set t_Co=256
set background=dark
syntax on
colorscheme agalitsyn

set nobackup		" do not keep a backup file, use versions instead
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set hlsearch		" Highlight searches
set incsearch		" do incremental searching
set ignorecase		" Ignore case of searches.
set autoindent		" Copy indent from last line when starting new line.
set smartintend		" Know about functions end while intending
set number		" set line numbers
set cursorline    	" Highlight current line
set esckeys       	" Allow cursor keys in insert mode.
set showmode      	" Show the current mode.
set ruler         	" Show the cursor position
set nowrap        	" Do not wrap lines.
set magic         	" Enable extended regexes.
set smartcase     	" Ignore 'ignorecase' if search patter contains uppercase characters
set title         	" Show the filename in the window titlebar.
set undofile      	" Persistent Undo.

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

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
