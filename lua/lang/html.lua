local html = {}

html.lsp = {
    html = {
        cmd = { "vscode-html-language-server", "--stdio" },
        filetypes = { "html" },
        root_markers = { "package.json", ".git" },
    },
}

html.format = {
    formatters_by_ft = {
        html = { "prettier" },
    },
}

html.lint = {
    linters_by_ft = {
        html = { "htmlhint" },
    },
}

return html
