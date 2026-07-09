local fish = {}

fish.lsp = {
    fish_lsp = {},
}

fish.format = {
    formatters_by_ft = {
        fish = { "fish_indent" },
    },
}

fish.lint = {
    linters_by_ft = {
        fish = { "fish" },
    },
}

return fish
