local lua = {}

local generated = dofile(vim.fn.stdpath("cache") .. "/generated.lua")
local hyprland = generated.hyprland

lua.lsp = {
    lua_ls = {
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim", "require", "hl" } },
                workspace = {
                    preloadFileSize = 10000,
                    library = {
                        vim.env.VIMRUNTIME,
                        hyprland,
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
                "hl",
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
