""" Plugins
set nocompatible
filetype off
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline' " https://github.com/vim-airline/vim-airline
Plug 'vim-airline/vim-airline-themes' " https://github.com/vim-airline/vim-airline-themes
Plug 'tomasiser/vim-code-dark' " https://github.com/tomasiser/vim-code-dark
Plug 'tpope/vim-fugitive' " https://github.com/tpope/vim-fugitive
Plug 'tmhedberg/SimpylFold' " https://github.com/tmhedberg/SimpylFold
Plug 'scrooloose/nerdcommenter' " https://github.com/scrooloose/nerdcommenter
Plug 'jiangmiao/auto-pairs' " https://github.com/jiangmiao/auto-pairs
Plug 'codota/tabnine-vim' " https://github.com/codota/tabnine-vim
Plug 'scrooloose/nerdtree' " https://github.com/scrooloose/nerdtree
Plug 'alpertuna/vim-header' " https://github.com/alpertuna/vim-header
Plug 'ryanoasis/vim-devicons' " https://github.com/ryanoasis/vim-devicons
call plug#end()
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  autocmd VimEnter * PlugInstall --sync | qa!
endif
filetype plugin indent on
syntax enable

""" Commenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1
map <F4> <leader>ci <CR>

""" File Tree
map <F2> :NERDTreeToggle<CR>
let NERDTreeChDirMode = 1
let NERDTreeShowBookmarks = 1
let NERDTreeIgnore = ['\~$', '\.pyc$', '\.swp$']
let NERDTreeWinSize = 25

""" Color Theme
if &term =~ '256color'
  set t_Co=256
  set t_ut=
endif
if !empty(glob('~/.vim/plugged/vim-code-dark/autoload/airline/themes/codedark.vim'))
  colorscheme codedark
endif

""" Status Line
set guifont=SauceCodePro\ Nerd\ Font\ 13
let g:airline_powerline_fonts = 1
let g:airline_theme = 'codedark'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''

""" Header
let g:header_field_filename = 0
let g:header_field_timestamp = 0
let g:header_field_modified_timestamp = 0
let g:header_field_modified_by = 0

""" Common
set encoding=utf-8
set hlsearch
set backspace=2
set cursorline
set ignorecase
set laststatus=2
set showtabline=2
set noshowmode
set tabstop=4
set shiftwidth=4
set expandtab