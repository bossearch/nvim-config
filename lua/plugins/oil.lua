return {
    spec = {
        src = "https://github.com/stevearc/oil.nvim",
    },
    "oil.nvim",
    cmd = "Oil",
    after = function()
        require("oil").setup()
    end,
}
