" ---
" Configuration: Plugin Manager
"
" References:
" 	[1] https://github.com/tpope/vim-pathogen
" ---
execute pathogen#infect()
syntax on
filetype plugin indent on

" ---
" Configuration: Tokyo Night Theme
"
" References:
" 	[1] https://github.com/ghifarit53/tokyonight-vim
" ---
:set bg=dark
set termguicolors
let g:tokyonight_style = 'night'
let g:tokyonight_enable_italic = 1
let g:lightline = {'colorscheme': 'tokyonight'}
autocmd vimenter * ++nested colorscheme tokyonight

" ---
" Configuration: Code-minimap
"
" Requirements:
" 	[R1] Code-minimap: https://github.com/wfxr/code-minimap
"
" References:
" 	[1] https://github.com/wfxr/minimap.vim
" ---
let g:minimap_width = 10
let g:minimap_auto_start = 1
let g:minimap_auto_start_win_enter = 1

call plug#begin()

Plug 'junegunn/fzf'
Plug 'ghifarit53/tokyonight-vim'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'junegunn/vim-easy-align'
Plug 'mbbill/undotree'
Plug 'wellle/context.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/rainbow_parentheses.vim'

call plug#end()
" ---
"  Configuration: NerdTree
" ---
"nnoremap <leader>n :NERDTreeFocus<CR>
"remap <C-n> :NERDTree<CR>
"remap <C-t> :NERDTreeToggle<CR>
"remap <C-f> :NERDTreeFind<CR>

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" ---
" Configuration: Easy Align Plugin
" ---
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" ---
" Configuration: undotree
" ---
nnoremap <F5> :UndotreeToggle<CR>

" ---
" Configuration: Set RainbowParentheses to autostart when VIm starts
" ---
autocmd VimEnter * :RainbowParentheses

" ---
" Configuration: line number
" ---
set number
set relativenumber
