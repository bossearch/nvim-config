-- Experimental wrapper for 'age'.
--
-- This script handles encryption keys and sensitive data. Make sure you have
-- proper backups before using it. Mistakes in configuration or usage may cause
-- data loss or unexpected behavior.
--
-- Use at your own risk.

local M = {}

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("md-age", { clear = true })
-- NOTE: assume the keyfile is already declared on AGE_KEY_FILE env
local keyfile = vim.env.AGE_KEY_FILE

function M.run_decryption(bufnr, filename)
    -- dont decrypt uncrypted file
    local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
    if not first_line:match("^age%-encryption") then
        return
    end

    -- setup secure buffer environment
    vim.bo[bufnr].modifiable = true
    vim.bo[bufnr].swapfile = false
    vim.bo[bufnr].undofile = false
    vim.g.shada = "!"

    -- run decryption command
    local cmd = string.format("age -d -i %s %s", vim.fn.shellescape(keyfile), vim.fn.shellescape(filename))
    local output = vim.fn.systemlist(cmd)

    if vim.v.shell_error ~= 0 then
        vim.notify("Decryption failed!", vim.log.levels.ERROR)
        return
    else
        vim.notify("File Decrypted.", vim.log.levels.INFO)
    end

    -- update buffer
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, output)
    vim.bo[bufnr].filetype = "markdown"
    vim.bo[bufnr].modified = false
    vim.b[bufnr].is_decrypted = true
    vim.b[bufnr].is_encrypted = false
end

function M.run_encryption(bufnr, filename, is_quitting)
    -- dont encrypt if already encrypted
    local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
    if first_line:match("^age%-encryption") then
        return
    end

    -- create new file with md.age extension
    local new_filename
    local is_already_age = filename:sub(-7) == ".md.age"

    if is_already_age then
        new_filename = filename
    else
        new_filename = filename .. ".age"
    end

    -- run encryption command
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local cmd = string.format("age -e -i %s -o %s", vim.fn.shellescape(keyfile), vim.fn.shellescape(new_filename))
    vim.fn.system(cmd, table.concat(lines, "\n"))

    if vim.v.shell_error ~= 0 then
        vim.notify("Encryption failed!", vim.log.levels.ERROR)
        return
    else
        if not is_already_age then
            vim.fn.delete(filename)
            vim.api.nvim_buf_set_name(bufnr, new_filename)
        end
        vim.notify("File encrypted.", vim.log.levels.INFO)
    end

    -- update buffer
    vim.b[bufnr].is_encrypted = true
    vim.b[bufnr].is_decrypted = false
    if not is_quitting then -- if we are quitting, do not call `edit!` (it causes race conditions on exits)
        vim.cmd("noautocmd edit!")
        vim.bo[bufnr].filetype = "binary"
    end
end

-- safety hooks to auto encrypt file just in case
local function auto_save_and_encrypt(ev)
    if vim.b[ev.buf].modified then
        vim.cmd("write!")
    end
    vim.schedule(function()
        if vim.b[ev.buf].is_decrypted and not vim.b[ev.buf].is_encrypted then
            M.run_encryption(ev.buf, ev.match, true)
        end
    end)
end

autocmd("BufUnload", {
    group = augroup,
    pattern = "*.md.age",
    callback = auto_save_and_encrypt,
})

autocmd("VimLeavePre", {
    group = augroup,
    pattern = "*.md.age",
    callback = auto_save_and_encrypt,
})

return M
