local python = {}

python.lsp = {
    ruff = {
        init_options = {
            settings = {
                lineLength = 79,
                fixAll = true,
                organizeImports = true,
                diagnostics = true,
            },
        },
    },
    basedpyright = {
        settings = {
            basedpyright = {
                analysis = {
                    typeCheckingMode = "recommended",
                    ignore = { "*" },
                },
            },
        },
    },
}

python.format = {
    formatters_by_ft = {
        python = { "ruff_format" },
    },
    formatters = {
        ruff_format = {
            command = "ruff",
        },
    },
}

python.lint = {
    linters_by_ft = {
        python = { "ruff" },
    },
    linters = {
        ruff = {
            cmd = "ruff",
        },
    },
}

return python
