return {
    "nvim-lint",
    spec = { src = "https://github.com/mfussenegger/nvim-lint" },
    event = { "BufReadPre", "BufNewFile" },
    after = function()
        local util = require("lib.util")
        local lint = require("lint")

        util.scan_modules("lua/lang", "lang.", function(lang)
            if lang.lint then
                if lang.lint.linters then
                    for name, config in pairs(lang.lint.linters) do
                        lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name] or {}, config)
                    end
                end

                if lang.lint.linters_by_ft then
                    lint.linters_by_ft = vim.tbl_deep_extend("force", lint.linters_by_ft, lang.lint.linters_by_ft)
                end
            end
        end)

        vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
            callback = function()
                lint.try_lint()
            end,
        })
    end,
}
