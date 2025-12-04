" Display
set number              " Show line numbers
set relativenumber      " Relative line numbers
set cursorline          " Highlight current line
set showcmd             " Show command in bottom bar
set showmatch           " Highlight matching brackets

" Indentation
set tabstop=4           " Tab = 4 spaces visually
set softtabstop=4       " Tab = 4 spaces when editing
set shiftwidth=4        " Indent = 4 spaces
set expandtab           " Use spaces instead of tabs
set autoindent          " Copy indent from current line
set smartindent         " Smart autoindenting on new lines

" Search
set incsearch           " Search as you type
set hlsearch            " Highlight search results
set ignorecase          " Case-insensitive search
set smartcase           " Case-sensitive if uppercase present

" Usability
set backspace=indent,eol,start  " Backspace works as expected
set scrolloff=8         " Keep 8 lines above/below cursor
set wildmenu            " Command-line completion
set clipboard=unnamed   " Use system clipboard

" Files
set noswapfile          " Disable swap files
set nobackup            " Disable backup files
syntax enable           " Syntax highlighting
filetype plugin indent on
