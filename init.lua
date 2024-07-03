-- Auto-install packer if not installed
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
  use 'ThePrimeagen/vim-be-good'
  use 'kylechui/nvim-surround'
  use 'gbprod/cutlass.nvim'
  use 'gbprod/substitute.nvim'
end)

-- Configure nvim-surround
require("nvim-surround").setup({
    -- Configuration options here
})

-- Configure cutlass
require('cutlass').setup({
  cut_key = 'x',
  override_del = nil,
  exclude = {},
})

-- Configure substitute
require('substitute').setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
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

-- Substitute mappings
vim.keymap.set("n", "s", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
vim.keymap.set("n", "ss", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
vim.keymap.set("n", "S", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
vim.keymap.set("x", "s", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })

vim.opt.clipboard:append("unnamedplus")

-- Auto-sync function
local function auto_sync()
  local handle = io.popen("git -C " .. vim.fn.stdpath("config") .. " status --porcelain")
  local result = handle:read("*a")
  handle:close()
  if result ~= "" then
    local output = vim.fn.system("git -C " .. vim.fn.stdpath("config") .. " add .")
    output = output .. vim.fn.system('git -C ' .. vim.fn.stdpath("config") .. ' commit -m "Auto-sync Neovim config"')
    output = output .. vim.fn.system("git -C " .. vim.fn.stdpath("config") .. " push")
    
    if output:match("error") or output:match("fatal") then
      print("Unusual messages during auto-sync:")
      print(output)
      vim.fn.input("Press Enter to continue...")
    else
      print("Neovim config auto-synced")
    end
  end
end

-- Set up autocmd for auto-sync on config file change
vim.api.nvim_create_autocmd({"BufWritePost"}, {
  pattern = vim.fn.stdpath("config") .. "/**/*.lua",
  callback = auto_sync
})

-- Sync settings on startup
auto_sync()

-- Set up highlight for yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  callback = function()
    vim.highlight.on_yank({higroup = 'IncSearch', timeout = 700})
  end,
})

-- Automatically set up your configuration after cloning packer.nvim
if packer_bootstrap then
  require('packer').sync()
end
