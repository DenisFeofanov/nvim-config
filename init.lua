   local ensure_packer = function()
     local fn = vim.fn
     local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
     if fn.empty(fn.glob(install_path)) > 0 then
       fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
       vim.cmd [[packadd packer.nvim]]
       return true
     end
     return false
   end

   local packer_bootstrap = ensure_packer()

-- Plugin management with packer
   require('packer').startup(function(use)
     use 'wbthomason/packer.nvim'
  use 'wbthomason/packer.nvim'
  use 'ThePrimeagen/vim-be-good'
  use 'kylechui/nvim-surround'
   end)

   -- Automatically set up your configuration after cloning packer.nvim
   -- Put this at the end after all plugins
   if packer_bootstrap then
     require('packer').sync()
   end
   
-- Configure nvim-surround
require("nvim-surround").setup({
    -- Configuration options here
})

-- Set options
vim.opt.number = true
vim.opt.relativenumber = true
vim.g.mapleader = " "

-- Key mappings
vim.keymap.set('n', '<leader>h', ':noh<CR>')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '<leader>s', '<Cmd>call VSCodeCall("workbench.action.gotoSymbol")<CR>')
vim.keymap.set('n', '<leader>w', '<Cmd>call VSCodeCall("workbench.action.showAllSymbols")<CR>')
vim.keymap.set('n', '<leader>f', '<Cmd>call VSCodeCall("actions.find")<CR>')
vim.keymap.set('n', '<leader>r', '<Cmd>call VSCodeCall("editor.action.startFindReplaceAction")<CR>')

vim.opt.clipboard:append("unnamedplus")

-- Auto-sync function
local function auto_sync()
  local handle = io.popen("git -C " .. vim.fn.stdpath("config") .. " status --porcelain")
  local result = handle:read("*a")
  handle:close()

  if result ~= "" then
    os.execute("git -C " .. vim.fn.stdpath("config") .. " add .")
    os.execute('git -C ' .. vim.fn.stdpath("config") .. ' commit -m "Auto-sync Neovim config"')
    os.execute("git -C " .. vim.fn.stdpath("config") .. " push")
    print("Neovim config auto-synced")
  end
end

-- Set up autocmd for auto-sync on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = auto_sync
})

