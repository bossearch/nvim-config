vim.loader.enable()

local extra_dirs = { "core", "lib" }
local config_dir = vim.fn.stdpath("config")
for _, dir_name in ipairs(extra_dirs) do
    local full_path = config_dir .. "/lua/" .. dir_name
    if vim.fn.isdirectory(full_path) == 1 then
        for name, type in vim.fs.dir(full_path) do
            if type == "file" and name:match("%.lua$") then
                local module = dir_name .. "." .. name:gsub("%.lua$", "")
                require(module)
            end
        end
    end
end

require("lib.util").get_nvim_startup_time()

vim.pack.add({ "https://github.com/lumen-oss/lz.n" }, { confirm = false })

local lz_table = {}
local pack_table = {}
local plugins_dir = config_dir .. "/lua/plugins"

local function add_spec(spec)
    local deps = spec.dependencies
    spec.dependencies = nil
    if deps then
        for _, dep in ipairs(deps) do
            if type(dep) == "table" then
                add_spec(dep)
            else
                table.insert(pack_table, dep)
            end
        end
    end
    table.insert(pack_table, spec)
end

for name, type in vim.fs.dir(plugins_dir) do
    if type == "file" and name:match("%.lua$") and not name:match("^%.") then
        local plugin = require("plugins." .. name:gsub("%.lua$", ""))
        if plugin.spec then
            add_spec(plugin.spec)
            plugin.spec = nil
        end

        table.insert(lz_table, plugin)
    end
end

require("lz.n").load(lz_table)

vim.api.nvim_create_user_command("PackInstall", function()
    vim.pack.add(pack_table, { confirm = false })
end, {})

vim.api.nvim_create_user_command("PackCleanup", function()
    local non_active = {}
    vim.pack.add(pack_table, { confirm = false })
    for _, pack in ipairs(vim.pack.get()) do
        if not pack.active then
            table.insert(non_active, pack.spec.name)
        end
    end
    if #non_active == 0 then
        vim.notify("No non-active plugins found")
        return
    end
    vim.notify("Non-active plugins:\n\n" .. table.concat(non_active, "\n"), vim.log.levels.WARN)
    if vim.fn.confirm("Delete " .. #non_active .. " plugin(s)?", "&Yes\n&No") == 1 then
        vim.pack.del(non_active)
        vim.notify("Deleted " .. #non_active .. " plugin(s)")
    end
end, {})

-- local f, err = io.open(vim.fn.stdpath("config") .. "/debug.lua", "w")
-- assert(f, err)
-- f:write("vim.pack.add(\n" .. vim.inspect(pack_table) .. "\n)")
-- f:write("\n\nrequire('lz.n').load(\n" .. vim.inspect(lz_table) .. "\n)")
-- f:close()
