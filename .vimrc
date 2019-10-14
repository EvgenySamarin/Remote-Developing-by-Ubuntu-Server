
" Пример настройки vimrc файла.
"
" Дата создания 2019.10.03
"
" for Unix and OS/2:  ~/.vimrc

call plug#begin('~/.vim/plugged')

Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'udalov/kotlin-vim'
Plug 'ycm-core/YouCompleteMe'
Plug 'jiangmiao/auto-pairs'

call plug#end()

let g:onedark_hide_endofbuffer=1
colorscheme onedark

syntax on
set number " нумерация строк
set mouse=a " Поддержка мышки
set expandtab "пробелы вместо табуляции
set tabstop=2 " Табуляция в 2 пробела
set hlsearch "подсветка поиска
set incsearch "инкрементальный поиск
set clipboard=unnamed

"мапинг клавиш для Нерда ctrl+N
map <C-n> : NERDTreeToggle<CR>
