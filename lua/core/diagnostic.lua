vim.diagnostic.config({
    enable = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticVirtualTextError",
            [vim.diagnostic.severity.WARN] = "DiagnosticVirtualTextWarn",
            [vim.diagnostic.severity.HINT] = "DiagnosticVirtualTextHint",
            [vim.diagnostic.severity.INFO] = "DiagnosticVirtualTextInfo",
        },
    },
    float = {
        source = false,
        border = "solid",
        header = "",
        scope = "line",
        prefix = "",
        suffix = "",
        format = function(diagnostic)
            return diagnostic.message
        end,
    },
    underline = false,
    severity_sort = true,
})

-- Auto open diagnostic floating window
vim.api.nvim_create_autocmd("CursorHold", {
    group = vim.api.nvim_create_augroup("DiagnosticHover", { clear = true }),
    callback = function()
        vim.diagnostic.open_float(nil, {
            focusable = false,
            close_events = {
                "BufLeave",
                "CursorMoved",
                "DiagnosticChanged",
                "InsertEnter",
                "WinLeave",
            },
        })
    end,
})
