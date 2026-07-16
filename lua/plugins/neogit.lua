return {
    {
        "neogit",
        spec = { src = "https://github.com/NeogitOrg/neogit" },
        keys = {
            { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
        },
        before = function()
            require("lz.n").trigger_load("baleia.nvim")
        end,
        after = function()
            require("neogit").setup({
                mappings = {
                    popup = {
                        -- disable diffview
                        ["d"] = false,
                    },
                },
                graph_style = "ascii", -- can be "ascii" or "unicode"
                log_pager = { "delta-neogit", "--file-style", "omit" },
                process_spinner = true,
                highlight = {
                    italic = true,
                    bold = true,
                    underline = true,
                },
                commit_order = "topo", -- can be "topo", "date", "author-date" or ""
                notification_icon = "󰊢",
                signs = {
                    hunk = { "", "" },
                    item = { "", "" },
                    section = { "", "" },
                },
            })
        end,
    },
    {
        "baleia.nvim",
        spec = { src = "https://github.com/m00qek/baleia.nvim" },
        lazy = true,
        after = function()
            vim.g.baleia = require("baleia").setup()
        end,
    },
}
