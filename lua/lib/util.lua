local util = {}

-- usercmd --
util.copy_to_clipboard = function(content)
    vim.fn.setreg("+", content)
    vim.notify('Copied "' .. content .. '" to the clipboard!', vim.log.levels.INFO)
end

-- usercmd --
util.get_root_dir = function()
    local bufname = vim.fn.expand('%:p')
    if vim.fn.filereadable(bufname) == 0 then
        return
    end

    local parent = vim.fn.fnamemodify(bufname, ':h')
    local git_root = vim.fn.systemlist('git -C ' .. parent .. ' rev-parse --show-toplevel')
    if #git_root > 0 and git_root[1] ~= '' then
        return git_root[1]
    else
        return parent
    end
end

-- startuptime --
util.get_nvim_startup_time = function()
    if vim.g.saved_startuptime then
        local ms = vim.g.saved_startuptime.startup.mean
        if ms then
            return string.format("%.2fms", ms)
        end
    end
    return "???"
end

-- tips --
util.get_tips = function()
    local function wrap_text(text, max_width)
        local lines, current = {}, ""
        for line in text:gmatch("[^\n]+") do
            for word in line:gmatch("%S+") do
                if #current == 0 then
                    current = word
                elseif #current + #word + 1 <= max_width then
                    current = current .. " " .. word
                else
                    table.insert(lines, current)
                    current = word
                end
            end
            if #current > 0 then
                table.insert(lines, current)
                current = ""
            end
        end
        return table.concat(lines, "\n")
    end

    local tips_file = vim.fn.stdpath('config') .. '/lua/lib/tips.lua'

    local ok, tips = pcall(dofile, tips_file)
    if not ok or type(tips) ~= "table" or #tips == 0 then
        return "No tips available!"
    end

    math.randomseed(os.time() + math.random(1000000))
    local tip = tips[math.random(1, #tips)]

    return wrap_text(tip, 60)
end

-- smart buffer delete --
util.smart_bdelete = function()
    if vim.bo.filetype == "fyler" then
        vim.cmd("TmuxNavigateRight")
        return
    end
    if (vim.api.nvim_win_get_width(0) < (vim.o.columns - 37)) or
        (vim.api.nvim_win_get_height(0) < (vim.o.lines - 2)) then
        vim.cmd("close")
    else
        vim.cmd("b #")
        local alt_bufnr = tonumber(vim.fn.bufnr("#"))
        if alt_bufnr > 0 and vim.api.nvim_buf_is_valid(alt_bufnr) then
            vim.api.nvim_buf_delete(alt_bufnr, { force = false })
        else
            vim.cmd("quitall")
        end
    end
end

return util
