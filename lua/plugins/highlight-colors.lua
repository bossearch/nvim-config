return {
    "nvim-highlight-colors",
    spec = { src = "https://github.com/brenoprata10/nvim-highlight-colors" },
    event = { "BufReadPre", "BufNewFile" },
    after = function()
        require("nvim-highlight-colors").setup({
            enable_ansi = true,
            enable_hex = true,
            enable_hsl = true,
            enable_hsl_without_function = true,
            enable_named_colors = true,
            enable_rgb = true,
            enable_short_hex = true,
            enable_tailwind = true,
            enable_var_usage = true,
            enable_xterm256 = true,
            enable_xtermTrueColor = true,
            render = "background",
        })
    end,
}
