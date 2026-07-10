return {
    "guess-indent.nvim",
    spec = { src = "https://github.com/nmac427/guess-indent.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    after = function()
        require("guess-indent").setup()
    end,
}
