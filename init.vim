call plug#begin('~/.local/share/nvim/plugged')

Plug 'ThePrimeagen/vim-be-good'
Plug 'kylechui/nvim-surround'

call plug#end()

" Configure nvim-surround
lua << EOF
require("nvim-surround").setup({
    -- Configuration options here
})
EOF


set number
set relativenumber
let mapleader = "\<Space>"
nnoremap <leader>h :noh<CR>
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz
nnoremap n nzzzv
nnoremap N Nzzzv
nmap <leader>s <Cmd>call VSCodeCall('workbench.action.gotoSymbol')<CR>
nmap <leader>w <Cmd>call VSCodeCall('workbench.action.showAllSymbols')<CR>
nmap <leader>f <Cmd>call VSCodeCall('actions.find')<CR>
nmap <leader>r <Cmd>call VSCodeCall('editor.action.startFindReplaceAction')<CR>
set clipboard+=unnamedplus

