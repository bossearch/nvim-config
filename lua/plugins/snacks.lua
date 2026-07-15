return {
    "snacks.nvim",
    spec = { src = "https://github.com/folke/snacks.nvim" },
    keys = require("plugins.extra.snacks-key").keys,
    event = { "BufReadPre", "BufNewFile" },
    after = function()
        require("snacks").setup({
            bigfile = { enabled = true },
            image = { enabled = false },
            input = { enabled = true },
            picker = require("plugins.extra.snacks-picker"),
        })
        require("plugins.extra.snacks-key").keymap()
    end,
}
