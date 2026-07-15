return {
    "render-markdown.nvim",
    spec = { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
    ft = "markdown",
    after = function()
        require("render-markdown").setup({
            completions = { lsp = { enabled = true } },
            file_types = { "markdown" },
            heading = {
                icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
            },
            latex = { enabled = false },
            sign = {
                enabled = false,
            },
        })
    end,
}
