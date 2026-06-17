return {
    "mini.pick",
    spec = {
        src = "https://github.com/echasnovski/mini.pick",
    },
    event = { "VimEnter" },
    after = function()
        require("mini.pick").setup()
    end,
}
