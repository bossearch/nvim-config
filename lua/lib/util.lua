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
            if base_name ~= "init" then
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
end

-- total window --
util.get_window = function()
    local tab_wins = vim.fn.gettabinfo(vim.fn.tabpagenr())[1].windows
    local total_window = vim.tbl_filter(function(win_id)
        local config = vim.api.nvim_win_get_config(win_id)
        return config.relative == ""
    end, tab_wins)
    return total_window
end

-- usercmd --
util.copy_to_clipboard = function(content, plain)
    vim.fn.setreg("+", content)
    if plain then
        vim.notify("Copied to the clipboard!", vim.log.levels.INFO)
    else
        vim.notify('Copied "' .. content .. '" to the clipboard!', vim.log.levels.INFO)
    end
end

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

return util
