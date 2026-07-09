local c = {}

c.lsp = {
    clangd = {
        capabilities = {
            offsetEncoding = { "utf-16" },
        },
        on_init = function(client)
            client.server_capabilities.signatureHelpProvider = false
        end,
    },
}

c.format = {
    formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
    },
    formatters = {
        clang_format = {
            command = "clang-format",
        },
    },
}

c.lint = {
    linters_by_ft = {
        c = { "clangtidy" },
        cpp = { "clangtidy" },
    },
    linters = {
        clangtidy = {
            cmd = "clang-tidy",
        },
    },
}
return c
