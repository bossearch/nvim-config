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

-- lsp progress --
local spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local client_progress = {}
local opts = {
    show_default_progress = true,
}
local orig_progress_handler = vim.lsp.handlers["$/progress"]

vim.lsp.handlers["$/progress"] = function(err, msg, ctx)
    local client_id = ctx.client_id
    local token = msg.token
    local value = msg.value

    if not client_progress[client_id] then
        client_progress[client_id] = {}
    end

    if value.kind == "begin" then
        client_progress[client_id][token] = true
    elseif value.kind == "end" then
        client_progress[client_id][token] = nil
    end

    if next(client_progress[client_id]) == nil then
        client_progress[client_id] = nil
    end

    if opts.show_default_progress and orig_progress_handler then
        orig_progress_handler(err, msg, ctx)
    end
end

M.lsp_status = function()
    local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
    if #clients == 0 then
        return "No LSP 󰒏"
    end

    local hrtime = (vim.uv or vim.loop).hrtime
    local frame = spinner_symbols[(math.floor(hrtime() / (1e6 * 100)) % #spinner_symbols) + 1]

    local client_names = {}
    local is_loading = false

    for _, client in ipairs(clients) do
        table.insert(client_names, client.name)
        if client_progress[client.id] ~= nil then
            is_loading = true
        end
    end

    local icon = is_loading and frame or "󰒋"
    return table.concat(client_names, ":") .. " " .. icon
end

return M
