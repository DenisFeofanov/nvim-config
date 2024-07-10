-- Auto-install Packer if not present
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

    -- Automatically set up your configuration after cloning packer.nvim
    if packer_bootstrap then
        require('packer').sync()
    end
end)

-- Auto-install plugins
vim.api.nvim_create_autocmd("User", {
    pattern = "PackerComplete",
    callback = function()
        vim.cmd "bw | silent! MasonUpdate" -- close packer window
        require("packer").compile()
        vim.api.nvim_exec_autocmds("User", { pattern = "ConfigReady" })
    end,
})

-- Configure plugins after they're installed
vim.api.nvim_create_autocmd("User", {
    pattern = "ConfigReady",
    callback = function()
        -- Configure nvim-surround
        require("nvim-surround").setup({
            -- Configuration options here
        })

        -- Configure cutlass
        require('cutlass').setup({
            cut_key = 'x',
            override_del = nil,
            exclude = {}
        })

        -- Configure substitute
        require('substitute').setup({
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        })
    end,
})

-- Set options
vim.opt.number = true
vim.opt.relativenumber = true
vim.g.mapleader = " "
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Key mappings

vim.api.nvim_set_keymap('n', '<leader>c', ':lua open_nvim_config()<CR>', {
    noremap = true,
    silent = true
})
vim.keymap.set('n', '<leader>h', ':noh<CR>')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '<leader>s', '<Cmd>call VSCodeCall("workbench.action.gotoSymbol")<CR>')
vim.keymap.set('n', '<leader>w', '<Cmd>call VSCodeCall("workbench.action.showAllSymbols")<CR>')
vim.keymap.set('n', '<leader>f', '<Cmd>call VSCodeCall("actions.find")<CR>')
vim.keymap.set('n', '<leader>r', '<Cmd>call VSCodeCall("editor.action.startFindReplaceAction")<CR>')
vim.keymap.set('n', '<CR>', "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>")
vim.api.nvim_set_keymap('n', '<leader>sync', ':lua sync_nvim_config()<CR>', { noremap = true, silent = true })

-- Substitute mappings
vim.keymap.set("n", "s", "<cmd>lua require('substitute').operator()<cr>", {
    noremap = true
})
vim.keymap.set("n", "ss", "<cmd>lua require('substitute').line()<cr>", {
    noremap = true
})
vim.keymap.set("n", "S", "<cmd>lua require('substitute').eol()<cr>", {
    noremap = true
})
vim.keymap.set("x", "s", "<cmd>lua require('substitute').visual()<cr>", {
    noremap = true
})

vim.opt.clipboard:append("unnamedplus")
   


-- Set up highlight for yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight_yank', {}),
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 200
        })
    end
})

-- Function to open Neovim configuration
_G.open_nvim_config = function()
    vim.cmd('edit ~/.config/nvim/init.lua')
end

-- Function to sync Neovim config
_G.sync_nvim_config = function()
    local handle = io.popen("cd ~/.config/nvim && git pull && git add . && git commit -m 'Auto-sync Neovim config' && git push")
    if handle then
        local result = handle:read("*a")
        handle:close()
        print("Neovim config synced: " .. result)
    else
        print("Failed to sync Neovim config")
    end
end

