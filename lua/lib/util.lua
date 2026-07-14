local util = {}

-- scan_modules --
--- @param sub_dir string The directory path relative to the config root (e.g., "lua/core")
--- @param require_prefix string The prefix string used for requiring (e.g., "core.")
--- @param callback? function The logic to execute when a module is successfully found and loaded
util.scan_modules = function(sub_dir, require_prefix, callback)
    local config_dir = vim.fn.stdpath("config")
    local full_path = config_dir .. "/" .. sub_dir
    if vim.fn.isdirectory(full_path) ~= 1 then
        return
    end

    for name, type in vim.fs.dir(full_path) do
        if type == "file" and name:match("%.lua$") and not name:match("^%.") then
            local base_name = name:gsub("%.lua$", "")
            local module_path = require_prefix .. base_name
            local success, module = pcall(require, module_path)
            if success then
                if callback then
                    callback(module, base_name)
                end
            else
                vim.notify(
                    string.format("Failed to load module %s:\n%s", module_path, module),
                    vim.log.levels.ERROR,
                    { title = "Scan Modules" }
                )
            end
        end
    end
end

-- usercmd --
util.copy_to_clipboard = function(content)
    vim.fn.setreg("+", content)
    vim.notify('Copied "' .. content .. '" to the clipboard!', vim.log.levels.INFO)
end

-- usercmd --
util.get_root_dir = function()
    local bufname = vim.fn.expand("%:p")
    if vim.fn.filereadable(bufname) == 0 then
        return
    end

    local parent = vim.fn.fnamemodify(bufname, ":h")
    local git_root = vim.fn.systemlist("git -C " .. parent .. " rev-parse --show-toplevel")
    if #git_root > 0 and git_root[1] ~= "" then
        return git_root[1]
    else
        return parent
    end
end

-- lualine --
util.get_cwd = function()
    local cwd = vim.fn.getcwd()
    local cwd_name = "󰝰 " .. vim.fn.fnamemodify(cwd, ":t")
    return cwd_name
end

util.filename = function()
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

    local max_width = math.floor(vim.o.columns / 2)
    if #path > max_width then
        path = vim.fn.pathshorten(path)
        if #path > max_width then
            path = "..." .. string.sub(path, #path - max_width + 4)
        end
    end

    return path .. status
end

util.no_lsp = function()
    local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
    if #clients == 0 then
        return "No LSP 󰒏"
    else
        return ""
    end
end

util.separator = function(sep, persist_sep)
    if vim.bo.buftype ~= "" then
        return persist_sep or ""
    end
    return sep
end

return util
