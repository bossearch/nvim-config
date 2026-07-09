local json = {}

json.lsp = {
    jsonls = {
        cmd = { "vscode-json-language-server", "--stdio" },
        filetypes = { "json", "jsonc" },
        root_markers = { "package.json", ".git" },
        settings = {
            json = {
                validate = { enable = true },
            },
        },
    },
}

json.format = {
    formatters_by_ft = {
        json = { "jq" },
    },
}

return json
