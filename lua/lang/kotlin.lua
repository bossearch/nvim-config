local kotlin = {}

kotlin.lsp = {
    kotlin_language_server = {},
}

kotlin.format = {
    formatters_by_ft = {
        kotlin = { "ktlint" },
    },
}

kotlin.lint = {
    linters_by_ft = {
        kotlin = { "ktlint" },
    },
}

return kotlin
