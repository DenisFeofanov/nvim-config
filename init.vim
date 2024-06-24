   call plug#begin('~/.local/share/nvim/plugged')

   " Add VimBeGood plugin
   Plug 'ThePrimeagen/vim-be-good'

   call plug#end()
   
   set number
   set relativenumber
   let mapleader = "\<Space>"
   nnoremap <leader>h :noh<CR>
   nnoremap <C-u> <C-u>zz
   nnoremap <C-d> <C-d>zz
