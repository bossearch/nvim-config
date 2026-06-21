return {
    "gitsigns.nvim",
    spec = { src = "https://github.com/lewis6991/gitsigns.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    after = function()
        require("gitsigns").setup({
            current_line_blame = true,
            current_line_blame_formatter = "<author>, <committer_time:%R> • <summary>",
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                changedelete = { text = "≃" },
                delete = { show_count = true, text = "-" },
                topdelete = { text = "‾" },
                untracked = { text = "?" },
            },
            signs_staged_enable = false,
        })
    end,
}
