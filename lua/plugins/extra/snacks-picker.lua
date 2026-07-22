local snacks = package.loaded["plugins.custom.colorscheme.integrations.snacks"]
local custom_hl = snacks.custom_hl

local custom_ivy = {
    layout = {
        backdrop = false,
        row = -1,
        border = "none",
        box = "vertical",
        {
            win = "input",
            height = 1,
            border = "top",
            title = "{title} {live} {flags}",
            title_pos = "center",
        },
        {
            win = "list",
            border = "top",
            height = 20,
        },
    },
}

return {
    enabled = true,
    prompt = " ",
    layout = {
        preset = "full",
    },
    layouts = {
        full = {
            layout = {
                backdrop = false,
                height = (vim.o.lines - 1),
                border = "none",
                box = "vertical",
                {
                    win = "preview",
                    border = "none",
                },
                {
                    win = "input",
                    height = 1,
                    border = "top",
                    title = "{title} {live} {flags}",
                    title_pos = "center",
                },
                {
                    win = "list",
                    border = "top",
                    height = 20,
                },
            },
        },
        -- change full_no_preview to ivy so neogit can use this
        ivy = custom_ivy,
        -- change vscode to use same layout as ivy for opencode
        vscode = custom_ivy,
        select = {
            layout = {
                relative = "cursor",
                backdrop = false,
                max_width = 67,
                border = "none",
                box = "vertical",
                {
                    win = "input",
                    height = 1,
                    border = "top",
                    title = "{title} {live} {flags}",
                    title_pos = "center",
                    wo = { winhighlight = custom_hl },
                },
                {
                    win = "list",
                    border = "top",
                    height = 10,
                    wo = { winhighlight = custom_hl },
                },
            },
        },
    },
    win = {
        input = {
            keys = {
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
                colorcolumn = "80,120",
            },
        },
    },
    formatters = {
        file = {
            filename_first = true,
            truncate = "center",
            icon_width = 2,
        },
    },
    previewers = {
        diff = {
            style = "terminal",
            cmd = { "delta" },
        },
    },
    db = {
        sqlite3_path = vim.env.SQLITE_PATH,
    },
    matcher = {
        cwd_bonus = false,
        frecency = true,
        history_bonus = true,
    },
}
