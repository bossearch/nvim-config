return {
    "conform.nvim",
    spec = { src = "https://github.com/stevearc/conform.nvim" },
    event = { "BufWrite" },
    after = function()
        local util = require("lib.util")
        local conform_opts = {
            format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                return { timeout_ms = 500, lsp_format = "fallback" }
            end,
            formatters = {},
            formatters_by_ft = {},
            notify_on_error = true,
        }

        util.scan_modules("lua/lang", "lang.", function(lang)
            if lang.format then
                conform_opts = vim.tbl_deep_extend("force", conform_opts, lang.format)
            end
        end)

        require("conform").setup(conform_opts)
    end,
}
