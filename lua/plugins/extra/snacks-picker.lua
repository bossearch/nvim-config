local heightFull = function(layout)
    if vim.bo.filetype == "alpha" then
        layout.opts.backdrop = { bg = _G.SnacksBackdrop, blend = 0 }
    else
        layout.opts.backdrop = false
    end
    return vim.o.lines - 3
end
local heightIvy = function(layout)
    local height
    if vim.bo.filetype == "alpha" then
        layout.opts.backdrop = { bg = _G.SnacksBackdrop, blend = 0 }
        height = (vim.o.lines - 3)
    else
        layout.opts.backdrop = false
        height = 0.4
    end
    return height
end

return {
    enabled = true,
    prompt = " ",
    layout = {
        preset = function()
            return vim.o.columns >= 120 and "full" or "full_no_preview"
        end,
    },
    layouts = {
        full = {
            reverse = true,
            layout = {
                backdrop = true,
                height = heightFull,
                border = "bottom",
                box = "vertical",
                wo = {},
                {
                    win = "preview",
                    height = 0.7,
                    border = "bottom",
                },
                { win = "list", border = "none" },
                {
                    win = "input",
                    height = 1,
                    border = "top",
                    title = "{title} {live} {flags}",
                    title_pos = "center",
                },
            },
        },
        full_no_preview = {
            reverse = true,
            layout = {
                backdrop = false,
                height = heightFull,
                border = "bottom",
                box = "vertical",
                { win = "list", border = "none" },
                {
                    win = "input",
                    height = 1,
                    border = "top",
                    title = "{title} {live} {flags}",
                    title_pos = "center",
                },
            },
        },
        ivy = {
            reverse = true,
            layout = {
                backdrop = true,
                height = heightIvy,
                row = -1,
                border = "bottom",
                box = "vertical",
                wo = {},
                { win = "list", border = "top" },
                {
                    win = "input",
                    height = 1,
                    border = "top",
                    title = "{title} {live} {flags}",
                    title_pos = "center",
                },
            },
        },
        select_icons = {
            hidden = { "preview" },
            layout = {
                backdrop = false,
                max_width = 67,
                max_height = 12,
                box = "vertical",
                border = "top",
                title = "{title}",
                title_pos = "center",
                { win = "input", height = 1, border = "bottom" },
                { win = "list", border = "none" },
            },
        },
    },
    win = {
        input = {
            keys = {
                ["J"] = { "preview_scroll_down", mode = "n" },
                ["K"] = { "preview_scroll_up", mode = "n" },
                ["H"] = { "preview_scroll_left", mode = "n" },
                ["L"] = { "preview_scroll_right", mode = "n" },
                ["-"] = { "edit_split", mode = "n" },
                ["|"] = { "edit_vsplit", mode = "n" },
            },
        },
        preview = {
            wo = {
                number = true,
                relativenumber = false,
                statuscolumn = "",
                signcolumn = "yes:1",
                cursorlineopt = "both",
            },
        },
    },
    formatters = {
        file = {
            filename_first = true,
            min_width = 40,
            icon_width = 2,
        },
    },
    previewers = {
        diff = {
            style = "syntax",
            cmd = { "delta" },
        },
    },
}
