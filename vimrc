syntax on
set nocompatible
set tabstop=4 softtabstop=4
set relativenumber
set nu
set nohlsearch
set incsearch
set scrolloff=8
set colorcolumn=80
set path+=**
set wildmenu
set encoding=utf-8
set splitbelow splitright

" Map R to search and replace command 
nnoremap R :%s///gc<Left><Left><Left><Left>

" Make S take into account indentation
nnoremap S ^C

let mapleader = " "

nnoremap <Leader>w :w<CR>
nnoremap <Leader>z :wq<CR>
nnoremap <Leader>q :q!<CR>

" keep cursor fixed when going through instances
nnoremap n nzzzv
nnoremap N Nzzzv


nnoremap Y y$
nnoremap J mzJ`z

" Moving texts in all modes
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-j> <Esc>:m .+1<CR>==i
inoremap <C-k> <Esc>:m .-2<CR>==i
nnoremap <Leader>j :m .+1<CR>==
nnoremap <Leader>k :m .-2<CR>==


" Autocomplete in insert mode by pressing tab
inoremap <expr> <Tab> matchstr(getline('.'), '.\%' . col('.') . 'c') =~ '\k' ? "\<C-P>" : "\<Tab>"

" escape insert mode with jk or kj
imap jk <Esc>
imap kj <Esc>

" comment and uncomment
let @c="^i# \<Esc>j^"
let @u="^xxj^"
