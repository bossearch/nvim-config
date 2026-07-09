local util = require("lib.util")
local servers_to_enable = {}

util.scan_modules("lua/lang", "lang.", function(lang)
    if lang.lsp then
        for server_name, config in pairs(lang.lsp) do
            vim.lsp.config(server_name, config)
            table.insert(servers_to_enable, server_name)
        end
    end
end)

vim.lsp.enable(servers_to_enable)
