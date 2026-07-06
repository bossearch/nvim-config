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

-- startuptime --
util.get_nvim_startup_time = function()
    local function send_event()
        vim.api.nvim_exec_autocmds("User", {
            pattern = "startuptime-loaded",
        })
    end

    local function get_ms_from_file()
        local file = io.open("/tmp/nvim-startup.log", "r")
        local prev_line = nil
        local last_line = nil
        for line in file:lines() do
            prev_line = last_line
            last_line = line
        end
        if not prev_line then
            return
        end
        local raw_ms = prev_line:match("([%d.]+)%s+[%d.]+:%s+%-+ NVIM STARTED %-+")
        return tonumber(raw_ms)
    end

    local function clear_file()
        local file = io.open("/tmp/nvim-startup.log", "w")
        file:close()
    end

    local timer = vim.uv.new_timer()
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
                util._startup_time = string.format("%.2f ms", ms)
                send_event()
                clear_file()
            elseif not ms then
                done = true
                util._startup_time = "???"
                send_event()
                clear_file()
            end
        end)
    )
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

	local tips_file = vim.fn.stdpath("config") .. "/lua/lib/tips.lua"

	local ok, tips = pcall(dofile, tips_file)
	if not ok or type(tips) ~= "table" or #tips == 0 then
		return "No tips available!"
	end

	math.randomseed(os.time() + math.random(1000000))
	local tip = tips[math.random(1, #tips)]

	return wrap_text(tip, 60)
end

-- lualine
util.get_cwd = function()
    local cwd = vim.fn.getcwd()
    local folder_name = vim.fn.fnamemodify(cwd, ":t")
    return folder_name
end

return util
