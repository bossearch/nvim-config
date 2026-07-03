return {
    "colorful-winsep.nvim",
    spec = { src = "https://github.com/nvim-zh/colorful-winsep.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    after = function()
        require("colorful-winsep").setup({
            anchor = {
                bottom = { width = 0, x = 1, y = 0 },
                left = { height = 1, x = -1, y = -1 },
                right = { height = 1, x = -1, y = 0 },
                up = { width = 0, x = -1, y = 0 },
            },
            animate = { enabled = false },
            border = { "─", "│", "┌", "┐", "└", "┘" },
            indicator_for_2wins = { position = false },
        })
    end,
}
