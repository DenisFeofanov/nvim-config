require("feofan")


local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
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
    use {
        'NeogitOrg/neogit',
        requires = {'nvim-lua/plenary.nvim', -- required dependency
        'sindrets/diffview.nvim', -- optional - for enhanced diff views
        'nvim-telescope/telescope.nvim' -- optional - for fuzzy finding
        },
        config = function()
            local neogit = require('neogit')
            neogit.setup {}
        end
    }
    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
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
-- Set options
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.relativenumber = true
-- Key mappings
vim.api.nvim_set_keymap('n', '<leader>i', ':lua open_nvim_config()<CR>', {
    noremap = true,
    silent = true
})
vim.keymap.set('n', '<leader>h', ':noh<CR>')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '<CR>', 'o<Esc>')
vim.keymap.set('n', '<leader><CR>', 'O<Esc>')
vim.keymap.set('n', '<leader>a', 'ggVG')
vim.keymap.set('n', '<leader>q', '<Cmd>call VSCodeCall("workbench.action.quickOpen")<CR>')
vim.keymap.set('n', '<leader>gc', '<Cmd>call VSCodeCall("git.viewChanges")<CR>')
vim.keymap.set('n', 'gt', '<Cmd>call VSCodeCall("editor.action.goToTypeDefinition")<CR>')
vim.keymap.set('n', '<leader>r', '<Cmd>call VSCodeCall("editor.action.startFindReplaceAction")<CR>')
vim.keymap.set('v', '<leader>f', '<Cmd>call VSCodeCall("actions.find")<CR>')
vim.keymap.set('v', '<leader>r', '<Cmd>call VSCodeCall("editor.action.startFindReplaceAction")<CR>')
vim.keymap.set('n', '<leader>b', 'va{V')
vim.keymap.set('n', '<leader>w', ':update<CR>', { silent = true })
vim.keymap.set('n', '<leader>e', '<Cmd>call VSCodeCall("workbench.action.closeEditorsInGroup")<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>i', ':lua open_nvim_config()<CR>', {
    noremap = true,
})
-- Better shortcut for commenting 
vim.keymap.set('', '<leader>c', 'gc', { remap = true })

-- Don't add a comment line when standing on a comment line
vim.cmd('autocmd BufEnter * set formatoptions-=cro')
vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')

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

vim.opt.hlsearch = false
