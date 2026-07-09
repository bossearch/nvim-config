local lua = {}

lua.lsp = {
    lua_ls = {
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim", "require" } },
                workspace = {
                    preloadFileSize = 10000,
                    library = {
                        vim.env.VIMRUNTIME,
                    },
                },
                telemetry = { enable = false },
            },
        },
    },
}

lua.format = {
    formatters_by_ft = {
        lua = { "stylua" },
    },
}

lua.lint = {
    linters_by_ft = {
        lua = { "luacheck" },
    },
    linters = {
        luacheck = {
            args = {
                "--globals",
                "vim",
                "--formatter",
                "plain",
                "--codes",
                "--ranges",
                "-",
            },
        },
    },
}

return lua
