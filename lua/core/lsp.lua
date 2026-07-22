-- remove neovim default lsp keymaps
local default_lsp_keys = {
    { { "n" }, "grn" },
    { { "n", "x" }, "gra" },
    { { "n" }, "grx" },
    { { "n" }, "grr" },
    { { "n" }, "gri" },
    { { "n" }, "grt" },
    { { "n" }, "gO" },
    { { "i", "s" }, "<C-S>" },
}

for _, map in ipairs(default_lsp_keys) do
    pcall(vim.keymap.del, map[1], map[2])
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("lazy_load_lsp", { clear = true }),
    callback = function(args)
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
        vim.api.nvim_del_augroup_by_id(args.group)
    end,
})
