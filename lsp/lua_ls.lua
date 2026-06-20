return {
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim", "require" } },
            workspace = {
                preloadFileSize = 10000,
                library = {
                    vim.env.VIMRUNTIME,
                }
            },
            telemetry = { enable = false },
        },
    },
}
