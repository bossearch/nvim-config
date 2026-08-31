return {
    "quicker.nvim",
    spec = { src = "https://github.com/stevearc/quicker.nvim" },
    ft = "qf",
    after = function()
        local icons = require("lib.icons").diagnostics
        require("quicker").setup({
            keys = {
                {
                    "<Tab>",
                    function()
                        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
                    end,
                    desc = "Expand quickfix context",
                },
                {
                    "<S-Tab>",
                    function()
                        require("quicker").collapse()
                    end,
                    desc = "Collapse quickfix context",
                },
            },
            borders = {
                vert = "│",
                strong_header = "─",
                strong_cross = "┼",
                strong_end = "┤",
                soft_header = "╌",
                soft_cross = "┼",
                soft_end = "┤",
            },
            type_icons = {
                E = icons.Error .. " ",
                W = icons.Warn .. " ",
                I = icons.Info .. " ",
                H = icons.Hint .. " ",
                N = "N ",
            },
        })
    end,
}
