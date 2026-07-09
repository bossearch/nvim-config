local css = {}

css.lsp = {
    cssls = {
        cmd = { "vscode-css-language-server", "--stdio" },
        filetypes = { "css", "scss", "less" },
        root_markers = { "package.json", ".git" },
        settings = {
            css = { validate = true },
            less = { validate = true },
            scss = { validate = true },
        },
    },
}

css.format = {
    formatters_by_ft = {
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
    },
}
css.lint = {
    linters_by_ft = {
        css = { "stylelint" },
        scss = { "stylelint" },
        less = { "stylelint" },
    },
}

return css
