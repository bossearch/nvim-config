vim.loader.enable()

local util = require("lib.util")

util.scan_modules("lua/core", "core.")

vim.pack.add({ "https://github.com/lumen-oss/lz.n" }, { confirm = false })

local lz_table = {}
local pack_table = {}

local function process_plugin(plugin)
    if plugin.spec then
        table.insert(pack_table, plugin.spec)
        plugin.spec = nil
    end
    table.insert(lz_table, plugin)
end

util.scan_modules("lua/plugins", "plugins.", function(plugins)
    if type(plugins[1]) == "table" then
        for _, p in ipairs(plugins) do
            process_plugin(p)
        end
    else
        process_plugin(plugins)
    end
end)

require("lib._alpha").get_startup_time()
require("lz.n").load(lz_table)

vim.pack.add(pack_table, { confirm = false })
vim.api.nvim_create_user_command("PackInstall", function()
    -- vim.pack.add(pack_table, { confirm = false })
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
