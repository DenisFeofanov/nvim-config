call plug#begin('~/.local/share/nvim/plugged')

" Add VimBeGood plugin
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

