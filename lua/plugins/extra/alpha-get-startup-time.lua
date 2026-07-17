local M = {}

M._startup_time = "???"
local done = false

local function send_event()
    vim.api.nvim_exec_autocmds("User", {
        pattern = "startuptime_loaded",
    })
end

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
    file:close() -- Always close file handlers to prevent leakages

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

M.start = function()
    local timer = vim.uv.new_timer()
    if not timer then
        return
    end
    timer:start(
        10,
        50,
        vim.schedule_wrap(function()
            if done then
                return
            end

            local ms = get_ms_from_file()
            if ms and ms > 10 then
                done = true
                M._startup_time = string.format("%.2f ms", ms)
                send_event()
                clear_file()
                timer:stop()
                timer:close()
            elseif not ms then
                done = true
                M._startup_time = "???"
                send_event()
                clear_file()
                timer:stop()
                timer:close()
            end
        end)
    )
end

M.start()

return M
