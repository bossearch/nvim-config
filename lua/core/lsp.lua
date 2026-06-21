vim.lsp.enable({ "lua_ls", "nixd", "bashls" })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("blink-cmp").get_lsp_capabilities(capabilities)

vim.lsp.config("*", {
    capabilities = capabilities,
})
