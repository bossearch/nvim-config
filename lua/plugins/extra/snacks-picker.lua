local snacks = package.loaded["plugins.custom.colorscheme.integrations.snacks"]
local snacks_backdrop = snacks.backdrop
local custom_hl = snacks.custom_hl

local function dynamic_layout_config(layout)
    if vim.bo.filetype == "alpha" then
        layout.opts.backdrop = { bg = snacks_backdrop, blend = 0 }
    else
        layout.opts.backdrop = false
    end
end

local height_full = function(layout)
    dynamic_layout_config(layout)
    return vim.o.lines - 2
end

local row_ivy = function(layout)
    dynamic_layout_config(layout)
    return -1
end
local custom_ivy = {
    layout = {
        row = row_ivy,
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
                height = height_full,
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
