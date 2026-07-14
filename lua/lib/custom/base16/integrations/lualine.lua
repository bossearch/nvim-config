return {
    setup = function(p)
        local base16_theme = {
            normal = {
                a = { fg = p.base01, bg = p.base0D, gui = "bold" },
                b = { fg = p.base0D, bg = p.base02 },
                c = { fg = p.base05, bg = p.base00 },
            },
            insert = {
                a = { fg = p.base01, bg = p.base0B, gui = "bold" },
                b = { fg = p.base0B, bg = p.base02 },
                c = { fg = p.base05, bg = p.base00 },
            },
            visual = {
                a = { fg = p.base01, bg = p.base0E, gui = "bold" },
                b = { fg = p.base0E, bg = p.base02 },
                c = { fg = p.base05, bg = p.base00 },
            },
            replace = {
                a = { fg = p.base01, bg = p.base08, gui = "bold" },
                b = { fg = p.base08, bg = p.base02 },
                c = { fg = p.base05, bg = p.base00 },
            },
            command = {
                a = { fg = p.base01, bg = p.base0A, gui = "bold" },
                b = { fg = p.base0A, bg = p.base02 },
                c = { fg = p.base05, bg = p.base00 },
            },
            terminal = {
                a = { fg = p.base01, bg = p.base0A, gui = "bold" },
                b = { fg = p.base0A, bg = p.base02 },
            },
            inactive = {
                a = { fg = p.base03, bg = p.base00 },
                b = { fg = p.base03, bg = p.base00 },
                c = { fg = p.base03, bg = p.base00 },
            },
            custom = {
                a = { fg = p.base05, bg = p.base00, gui = "nocombine" },
                b = { fg = p.base0E, bg = p.base00, gui = "nocombine" },
                c = { fg = p.base09, bg = p.base00, gui = "nocombine" },
            },
        }

        _G.lualine_theme = base16_theme
    end,
}
