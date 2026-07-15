vim.loader.enable()

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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

_G.pack_table = pack_table
require("lib.custom")
require("lz.n").load(lz_table)

-- local f, err = io.open(vim.fn.stdpath("config") .. "/debug.lua", "w")
-- assert(f, err)
-- f:write("vim.pack.add(\n" .. vim.inspect(pack_table) .. "\n)")
-- f:write("\n\nrequire('lz.n').load(\n" .. vim.inspect(lz_table) .. "\n)")
-- f:close()
