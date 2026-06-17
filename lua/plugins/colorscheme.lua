return {
    "rose-pine",
    spec = {
        name = "rose-pine",
        src = "https://github.com/rose-pine/neovim",
    },
    lazy = false,
    after = function()
        vim.cmd("colorscheme rose-pine")
    end,
}
