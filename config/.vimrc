" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')

" Install vim-airline https://github.com/vim-airline/vim-airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Install vim-devicons https://github.com/ryanoasis/vim-devicons
Plug 'ryanoasis/vim-devicons'

call plug#end()

" Run PlugInstall if there are missing plugins
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  autocmd VimEnter * PlugInstall --sync | source /usr/bin/vim
endif

" Configuration
set laststatus=2
set showtabline=2
set noshowmode

set t_Co=256
set guifont=SauceCodePro\ Nerd\ Font\ 13
set encoding=utf-8
set fileencoding=utf-8
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='luna'