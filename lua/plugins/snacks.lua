return {
    "snacks.nvim",
    spec = { src = "https://github.com/folke/snacks.nvim" },
    event = "User startuptime-loaded",
    after = function()
        require("snacks").setup({
            dashboard = {
                enabled = true,
                formats = {
                    file = function(item, ctx)
                        local path = vim.fn.fnamemodify(item.file, ":~")
                        local width = (ctx.width or 80) - 4

                        if #path <= width then
                            local dir = vim.fn.fnamemodify(path, ":h")
                            local file = vim.fn.fnamemodify(path, ":t")
                            return { { dir .. "/", hl = "dir" }, { file, hl = "file" } }
                        end

                        local filename = vim.fn.fnamemodify(path, ":t")
                        local parent = vim.fn.fnamemodify(vim.fn.fnamemodify(path, ":h"), ":t")
                        local base = vim.fn.fnamemodify(path, ":h:h")
                        local parts = vim.split(base, "/")

                        table.insert(parts, parent)
                        table.insert(parts, filename)

                        for i = 2, #parts - 2 do
                            for j = 2, i do
                                parts[j] = parts[j]:sub(1, 1)
                            end
                            local trial = table.concat(parts, "/")
                            if #trial <= width then
                                local dir = table.concat(vim.list_slice(parts, 1, #parts - 1), "/")
                                return { { dir .. "/", hl = "dir" }, { parts[#parts], hl = "file" } }
                            end
                        end

                        local short = "…" .. filename:sub(-math.max(1, width - #parent - 3))
                        return { { parent .. "/", hl = "dir" }, { short, hl = "file" } }
                    end,
                },
                preset = {
                    header = [[
    )       )        (      *
 ( /(    ( /(        )\ ) (  `
 )\())(  )\())(   ( (()/( )\))(
((_)\ )\((_)\ )\  )\ /(_)|(_)()\
 _((_|(_) ((_|(_)((_|_)) (_()((_)
| \| | __/ _ \ \ / /|_ _||  \/  |
| .` | _| (_) \ V /  | | | |\/| |
|_|\_|___\___/ \_/  |___||_|  |_|
]],
                    keys = {
                        {
                            action = ":lua MiniSessions.read('global-session')",
                            desc = "Restore Session",
                            icon = " ",
                            key = "s",
                            padding = 1,
                        },
                        { action = ":qa", desc = "Quit", icon = " ", key = "q" },
                    },
                },
                sections = {
                    { pane = 1,    section = "header" },
                    {
                        gap = 1,
                        icon = " ",
                        indent = 2,
                        limit = 10,
                        padding = 1,
                        section = "recent_files",
                        title = "Recent Files\n",
                    },
                    {
                        gap = 1,
                        icon = " ",
                        indent = 2,
                        limit = 5,
                        padding = 1,
                        pick = true,
                        section = "projects",
                        session = false,
                        title = "Projects\n",
                    },
                    { padding = 2, section = "keys" },
                    {
                        align = "center",
                        text = {
                            { require("lib.util").get_tips(), hl = "header" },
                            { "\n\n  ", hl = "desc" },
                            { "Neovim loaded in ", hl = "footer" },
                            { require('lib.util')._startup_time, hl = "key" }
                        },
                    },
                },
            },
        })
    end,
}
