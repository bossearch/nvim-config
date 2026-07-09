local bash = {}

bash.lsp = {
    bashls = {},
}

bash.format = {
    formatters_by_ft = {
        sh = { "shfmt" },
        bash = { "shfmt" },
    },
}

bash.lint = {
    linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
    },
}

return bash
