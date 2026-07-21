require("plugins.custom.color") -- autoload colorscheme
require("plugins.extra.alpha-get-startup-time")

-- lazy load normal plugins with lz.n
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

require("lib.util").scan_modules("lua/plugins", "plugins.", function(plugins)
    if type(plugins[1]) == "table" then
        for _, p in ipairs(plugins) do
            process_plugin(p)
        end
    else
        process_plugin(plugins)
    end
end)

_G.pack_table = pack_table

require("lz.n").load(lz_table)

-- debugging
-- local f, err = io.open(vim.fn.stdpath("config") .. "/debug.lua", "w")
-- assert(f, err)
-- f:write("vim.pack.add(\n" .. vim.inspect(pack_table) .. "\n)")
-- f:write("\n\nrequire('lz.n').load(\n" .. vim.inspect(lz_table) .. "\n)")
-- f:close()

-- lazy load customs
local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
    return vim.api.nvim_create_augroup("user" .. name, { clear = true })
end

autocmd({ "BufNewFile", "BufReadPre", "UIEnter" }, {
    group = augroup("lazy_load_custom_plugins"),
    callback = function(args)
        if args.event == "UIEnter" then
            require("plugins.custom.pack")
            require("plugins.custom.tmux")
        elseif args.event == "BufNewFile" or args.event == "BufReadPre" then
            require("plugins.custom.<C-w>q")
            require("plugins.custom.mark")
            require("plugins.custom.no-format")
            require("plugins.custom.scope")
            require("plugins.custom.todo")
        end
    end,
})
