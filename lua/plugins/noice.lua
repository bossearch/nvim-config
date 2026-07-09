return {
    {
        "noice.nvim",
        spec = { src = "https://github.com/folke/noice.nvim" },
        event = { "BufReadPre", "BufNewFile" },
        before = function()
            require("lz.n").trigger_load("nui.nvim")
        end,
        after = function()
            require("noice").setup({
                cmdline = { enabled = true, view = "cmdline" },
                notify = { enabled = false },
                popupmenu = { enabled = false },
                presets = { bottom_search = false, command_palette = false, long_message_to_split = true },
                routes = {
                    {
                        filter = {
                            event = "msg_show",
                            any = {
                                { find = "%d+L, %d+B" },
                                { find = "; after #%d+" },
                                { find = "; before #%d+" },
                            },
                        },
                        view = "mini",
                    },
                },
            })
        end,
    },
    {
        "nui.nvim",
        spec = { src = "https://github.com/MunifTanjim/nui.nvim" },
        lazy = true,
    },
}
