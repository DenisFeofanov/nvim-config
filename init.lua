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

-- Function to log messages
local log_file = vim.fn.stdpath("data") .. "/nvim_git_sync.log"
local function log_message(message)
    local file = io.open(log_file, "a")
    if file then
        file:write(os.date("%Y-%m-%d %H:%M:%S") .. " - " .. message .. "\n")
        file:close()
    end
end

-- Function to pull changes from Git
local function git_pull()
    local handle = io.popen("cd ~/.config/nvim && git pull 2>&1")
    if handle then
        local result = handle:read("*a")
        handle:close()
        log_message("Git pull result: " .. result)
        if result:match("Already up to date") then
            vim.notify("Neovim config is up to date", vim.log.levels.INFO)
        elseif result:match("Updating") then
            vim.notify("Pulled new changes for Neovim config", vim.log.levels.INFO)
        else
            vim.notify("Error pulling changes. Check log for details.", vim.log.levels.ERROR)
        end
    else
        log_message("Failed to execute git pull")
        vim.notify("Failed to execute git pull. Check log for details.", vim.log.levels.ERROR)
    end
end

-- Function to push changes to Git
local function git_push()
    local handle = io.popen("cd ~/.config/nvim && git add . && git commit -m 'Auto-commit on Neovim exit' && git push 2>&1")
    if handle then
        local result = handle:read("*a")
        handle:close()
        log_message("Git push result: " .. result)
        if result:match("nothing to commit") then
            vim.notify("No changes to push", vim.log.levels.INFO)
        elseif result:match("master -> master") then
            vim.notify("Pushed changes to Neovim config repository", vim.log.levels.INFO)
        else
            vim.notify("Error pushing changes. Check log for details.", vim.log.levels.ERROR)
        end
    else
        log_message("Failed to execute git push")
        vim.notify("Failed to execute git push. Check log for details.", vim.log.levels.ERROR)
    end
end

-- Function to display log contents
local function display_log()
    local file = io.open(log_file, "r")
    if file then
        local content = file:read("*all")
        file:close()
        vim.cmd("new")  -- Open a new buffer
        vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(content, "\n"))
        vim.bo.buftype = "nofile"
        vim.bo.bufhidden = "wipe"
        vim.bo.swapfile = false
        vim.bo.filetype = "log"
        vim.cmd("normal! G")  -- Move cursor to the end of the buffer
    else
        vim.notify("Could not open log file", vim.log.levels.ERROR)
    end
end

-- Set up autocommands for git operations
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("GitPullGroup", { clear = true }),
    callback = function()
        git_pull()
    end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("GitPushGroup", { clear = true }),
    callback = function()
        git_push()
    end,
})

-- Command to display log
vim.api.nvim_create_user_command("DisplayGitSyncLog", display_log, {})

-- Keybinding to display log
vim.api.nvim_set_keymap('n', '<leader>gl', ':DisplayGitSyncLog<CR>', { noremap = true, silent = true })
