local M = {}

M.get_cwd = function()
    local cwd = vim.fn.getcwd()
    local cwd_name = "󰝰 " .. vim.fn.fnamemodify(cwd, ":t")
    return cwd_name
end

M.filename = function()
    local status = ""
    if vim.bo.readonly then
        status = " [RO]"
    elseif vim.fn.expand("%:t") == "" then
        status = ""
    end

    local path = vim.fn.expand("%:.")
    if path == "" then
        path = "[No Name]"
    end

    return path .. status
end

M.no_lsp = function()
    local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
    if #clients == 0 then
        return "No LSP 󰒏"
    else
        return ""
    end
end

M.separator = function(sep)
    if vim.bo.buftype ~= "" then
        return ""
    end
    return sep
end

M.macro = function()
    local reg = vim.fn.reg_recording()
    if reg == "" then
        return ""
    end
    return "recording @" .. reg
end

return M
