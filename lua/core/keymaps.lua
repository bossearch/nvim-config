local set = vim.keymap.set
local opt = { noremap = true, silent = true }
vim.g.mapleader = " "
vim.g.maplocalleader = " "

set('n', '<leader>r', function()
    if vim.bo.modified then
        vim.cmd("update")
    end
    for module_name, _ in pairs(package.loaded) do
        if module_name:match("^core%.") or module_name:match("^plugins%.") then
            package.loaded[module_name] = nil
        end
    end
    vim.cmd("source " .. vim.fn.stdpath("config") .. "/init.lua")
    vim.notify("Config Reloaded!", vim.log.levels.INFO, { title = "Neovim" })
end, opt)

set('n', '<S-h>', ':bprev<CR>', opt)
set('n', '<S-l>', ':bnext<CR>', opt)

set({ 'n', 'v', 'x' }, '<leader>d', '"+d', opt)
set({ 'n', 'v', 'x' }, '<leader>y', '"+y', opt)
set({ 'n', 'v', 'x' }, '<leader>p', '"+p', opt)

set('n', '-', ':Oil<CR>', opt)
set('n', '<leader>f', ':Pick files<CR>', opt)
set('n', '<leader>h', ':Pick help<CR>', opt)

set('n', '<leader>mp', vim.lsp.buf.format, opt)
