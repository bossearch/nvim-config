local usercmd = vim.api.nvim_create_user_command
local util = require("lib.util")

usercmd("Copy", function(opts)
    local first_arg = {
        relative = "%",
        absolute = "%:p",
        name = "%:t",
        git = "git",
    }

    local format = first_arg[opts.fargs[1]]
    if not format then
        vim.notify("Usage: Copy <relative|absolute|name|git> [content]", vim.log.levels.ERROR)
        return
    elseif format == "git" then
        local has_range = (opts.range > 0)
        local mode = has_range and "v" or "n"
        require("plugins.custom.git-url").copy(mode, opts.line1, opts.line2)
        return
    end

    local base_path = vim.fn.expand(format)
    local second_arg = opts.fargs[2]
    local dont_notify = false

    local function get_path_with_range()
        if opts.range > 0 then
            if opts.line1 == opts.line2 then
                return string.format("%s:%d", base_path, opts.line1)
            else
                return string.format("%s:%d-%d", base_path, opts.line1, opts.line2)
            end
        end
        return base_path
    end

    local output = get_path_with_range()

    if second_arg == "content" then
        local start_line = opts.range > 0 and (opts.line1 - 1) or 0
        local end_line = opts.range > 0 and opts.line2 or -1
        local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)

        output = string.format("```%s\n%s\n```", output, table.concat(lines, "\n"))
        dont_notify = true
    elseif second_arg ~= nil then
        vim.notify("Invalid argument. Use: content", vim.log.levels.ERROR)
        return
    end

    util.copy_to_clipboard(output, dont_notify)
end, {
    nargs = "+",
    range = true,
    complete = function(arg_lead, cmd_line)
        local args = vim.tbl_filter(function(s)
            return s ~= ""
        end, vim.split(cmd_line, "%s+"))

        if #args == 1 or (#args == 2 and arg_lead ~= "") then
            return vim.tbl_filter(function(item)
                return item:find("^" .. arg_lead)
            end, { "relative", "absolute", "name", "git" })
        elseif #args == 2 or (#args == 3 and arg_lead ~= "") then
            -- don't autocomplete 'content' if the first argument was 'git'
            if args[2] == "git" then
                return {}
            end

            return vim.tbl_filter(function(item)
                return item:find("^" .. arg_lead)
            end, { "content" })
        end
    end,
})

usercmd("CurrentDir", function()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname == "" or vim.fn.filereadable(bufname) == 0 then
        return
    end
    local file_dir = vim.fn.fnamemodify(bufname, ":h")
    vim.cmd("lcd " .. vim.fn.fnameescape(file_dir))
end, {})

usercmd("RootDir", function()
    local root = util.get_root_dir()
    if root == "" then
        return
    end
    vim.cmd("lcd " .. root)
end, {})
