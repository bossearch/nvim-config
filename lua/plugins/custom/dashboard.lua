-- gh_contrib --
local colors = {
    ["#ebedf0"] = "GitHub0",
    ["#9be9a8"] = "GitHub1",
    ["#40c463"] = "GitHub2",
    ["#30a14e"] = "GitHub3",
    ["#216e39"] = "GitHub4",
}

local hl = vim.api.nvim_set_hl
hl(0, "GitHub0", { fg = "#414868" })
hl(0, "GitHub1", { fg = "#216e39" })
hl(0, "GitHub2", { fg = "#30a14e" })
hl(0, "GitHub3", { fg = "#40c463" })
hl(0, "GitHub4", { fg = "#9be9a8" })

local icons = {
    block_empty = "",
    circle_empty = "",
    block_full = "",
    circle_full = "",
}

local function gh_contrib()
    local file = os.getenv("HOME") .. "/.cache/" .. os.getenv("USER") .. "/gh-contrib"

    if vim.fn.filereadable(file) == 0 then
        return " file not found"
    end

    local days = {}
    for line in io.lines(file) do
        line = vim.trim(line)
        if line ~= "" then
            table.insert(days, line)
        end
    end

    local total_days = #days
    if total_days == 0 then
        return " file is empty "
    end

    local today_wday = os.date("*t").wday

    local chunks = {}
    local start_idx = math.max(1, total_days - 6)

    for i = start_idx, total_days do
        local color = days[i]
        local hl_group = colors[color]
        local is_empty = (color == "#ebedf0")
        local offset = total_days - i
        local wday = (today_wday - offset - 1) % 7 + 1
        local icon

        -- use circle icon for monday
        if wday == 2 then
            icon = is_empty and icons.circle_empty or icons.circle_full
        else
            icon = is_empty and icons.block_empty or icons.block_full
        end

        table.insert(chunks, "%#" .. hl_group .. "#" .. icon)
    end

    table.insert(chunks, "%*")
    return " " .. table.concat(chunks, " ")
end

-- startuptime --
local time = "??.?? ms"
local plugin_count = "??"

local function cache_plugin_count()
    local p = vim.pack.get()
    plugin_count = tostring(#p)
    return plugin_count
end

local function get_startuptime(on_complete)
    local done = false

    local function get_ms_from_file()
        local file = io.open("/tmp/nvim-startup.log", "r")
        if not file then
            return nil
        end

        local prev_line = nil
        local last_line = nil
        for line in file:lines() do
            prev_line = last_line
            last_line = line
        end
        file:close()

        if not prev_line then
            return nil
        end
        local raw_ms = prev_line:match("([%d.]+)%s+[%d.]+:%s+%-+ NVIM STARTED %-+")
        return tonumber(raw_ms)
    end

    local function clear_file()
        local file = io.open("/tmp/nvim-startup.log", "w")
        if file then
            file:close()
        end
    end

    local timer = vim.uv.new_timer()
    if not timer then
        return
    end

    timer:start(
        1,
        5,
        vim.schedule_wrap(function()
            if done then
                return
            end

            local ms = get_ms_from_file()
            if ms then
                done = true
                time = string.format("%.2f ms", ms)
                clear_file()
                timer:stop()
                timer:close()

                if on_complete then
                    cache_plugin_count()
                    on_complete()
                end
            end
        end)
    )
end

local function startuptime()
    return " Neovim lazy loaded " .. plugin_count .. " plugins in " .. time
end

-- version --
local function version()
    local v = vim.version()
    local currentver = "v" .. v.major .. "." .. v.minor .. "." .. v.patch .. " "
    local padding_len = (15 - #currentver)
    local padding = string.rep(" ", padding_len)
    return padding .. currentver
end

-- statusline --
_G.dashboard_render = function()
    return table.concat({
        gh_contrib(),
        "%=",
        startuptime(),
        "%=",
        version(),
    })
end

-- dashboard --
local function launch_dashboard()
    local dashboard_win = vim.api.nvim_get_current_win()

    local set = function(opt, val)
        vim.api.nvim_set_option_value(opt, val, { scope = "local" })
    end
    set("buflisted", false)
    set("bufhidden", "wipe")
    set("buftype", "nofile")
    set("colorcolumn", "")
    set("cursorline", false)
    set("filetype", "dashboard")
    set("modifiable", false)
    set("number", false)
    set("relativenumber", false)
    set("statuscolumn", "")
    set("swapfile", false)
    vim.opt.statusline = "%!v:lua.dashboard_render()"

    -- auto focus snacks picker input
    local group = vim.api.nvim_create_augroup("dashboard_unfocused", { clear = true })
    vim.api.nvim_create_autocmd("WinEnter", {
        group = group,
        callback = function()
            local active_pickers = require("snacks").picker.get()
            if #active_pickers > 0 and vim.api.nvim_get_current_win() == dashboard_win then
                active_pickers[1]:focus("input")
            end
        end,
    })

    require("lz.n").trigger_load("snacks.nvim")
    vim.schedule(function()
        require("snacks").picker.smart({
            auto_close = false,
            win = {
                input = {
                    keys = {
                        ["<Esc>"] = {
                            function()
                                vim.cmd("qa!")
                            end,
                            mode = "n",
                        },
                        ["s"] = {
                            function()
                                vim.cmd("lua require('mini.sessions').read('global-session')")
                            end,
                            mode = "n",
                        },
                    },
                },
            },
            on_close = function()
                pcall(vim.api.nvim_del_augroup_by_id, group)
            end,
        })
    end)
end

-- actually -- credit to "https://github.com/mong8se/actually.nvim"
local function open_actual(choice)
    if choice then
        local empty_bufnr = vim.api.nvim_win_get_buf(0)
        vim.cmd.edit(vim.fn.fnameescape(choice))
        vim.api.nvim_buf_delete(empty_bufnr, {})
    end
end

local function launch_actually(details)
    local target_path = (details and details.file) or vim.fn.expand("%")
    if not target_path or target_path == "" then
        return
    end

    local filename = vim.fn.fnameescape(target_path)

    if vim.fn.filereadable(filename) == 1 then
        return
    end

    local basename = vim.fs.basename
    local swapfile = basename(vim.fn.swapname(vim.fn.bufname(0)))

    local prev_fileignorecase = vim.o.fileignorecase
    vim.o.fileignorecase = true

    local possibilities = vim.tbl_filter(function(file)
        return #file > 1 and basename(file) ~= swapfile
    end, vim.fn.glob(filename .. "*", false, true))

    vim.o.fileignorecase = prev_fileignorecase

    if #possibilities > 0 then
        require("lz.n").trigger_load("snacks.nvim")

        vim.schedule(function()
            local picker_items = {}
            for _, file in ipairs(possibilities) do
                table.insert(picker_items, {
                    text = basename(file),
                    file = file,
                })
            end

            require("snacks").picker({
                auto_close = false,
                title = "Did you mean?",
                items = picker_items,
                layout = {
                    preset = "full",
                },
                confirm = function(picker, item)
                    picker:close()
                    if item then
                        open_actual(item.file)
                    end
                end,
            })
        end)
    end
end

get_startuptime(function()
    if vim.fn.argc() == 0 and vim.fn.expand("%") == "" then
        launch_dashboard()
    else
        launch_actually()
    end
end)
