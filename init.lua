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

-- Function to pull changes from Git
local function git_pull()
    local handle = io.popen("cd ~/.config/nvim && git pull 2>&1")
    if handle then
        local result = handle:read("*a")
        handle:close()
        if result:match("Already up to date") then
            print("Neovim config is up to date")
        elseif result:match("Updating") then
            print("Pulled new changes for Neovim config")
        else
            print("Error pulling changes: " .. result)
        end
    else
        print("Failed to execute git pull")
    end
end

-- Function to push changes to Git
local function git_push()
    local handle = io.popen(
        "cd ~/.config/nvim && git add . && git commit -m 'Auto-commit on Neovim exit' && git push 2>&1")
    if handle then
        local result = handle:read("*a")
        handle:close()
        if result:match("nothing to commit") then
            print("No changes to push")
        elseif result:match("master -> master") then
            print("Pushed changes to Neovim config repository")
        else
            print("Error pushing changes: " .. result)
        end
    else
        print("Failed to execute git push")
    end
end

-- Set up autocommands for git operations
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("GitPullGroup", {
        clear = true
    }),
    callback = function()
        git_pull()
    end
})

vim.api.nvim_create_autocmd("VimLeave", {
    group = vim.api.nvim_create_augroup("GitPushGroup", {
        clear = true
    }),
    callback = function()
        git_push()
    end
})
