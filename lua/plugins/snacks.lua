local Mappings = {
    files = "<leader><leader>f",
    nvim_config = "<leader><leader>n",
    icons = "<leader><leader>.",
    keymaps = "<leader><leader>k",
    recent = "<leader><leader>r",
    grep = "<leader><leader>g",
    grep_word = "<leader><leader>s",
    help = "<leader><leader>h",
    buffers = "<leader><leader>b",
    diagnostics = "<leader><leader>d",
    command_history = "<leader><leader>;",
    search_history = "<leader><leader>/",
    registers = "<leader><leader>'",
    marks = "<leader><leader>m",
    highlights = "<leader><leader>H",
    todos = "<leader><leader>t",
}

local lz_keys = {}
for _, key_combo in pairs(Mappings) do
    table.insert(lz_keys, { key_combo })
end

return {
    "snacks.nvim",
    spec = { src = "https://github.com/folke/snacks.nvim" },
    keys = lz_keys,
    after = function()
        local height = 0.6
        local function row()
            if vim.bo.filetype == "alpha" then
                return math.floor((vim.o.lines * (1 - height)) + 0.5)
            end
            return -1
        end
        local integration = package.loaded["lib.custom.base16.integrations.snacks"] or {}
        local custom_hl = integration.winhighlight_str or ""

        local function apply_todo_highlights(win)
            local my_matcher = package.loaded["lib.custom.todo"]
            if my_matcher and my_matcher.setup_highlights then
                my_matcher.setup_highlights(win.win)
            end
        end
        require("snacks").setup({
            bigfile = { enabled = true },
            image = { enabled = false },
            input = { enabled = true },
            picker = {
                enabled = true,
                -- ui_select = false,
                prompt = " ",
                layout = {
                    preset = function()
                        return vim.o.columns >= 120 and "ivy" or "ivy_no_preview"
                    end,
                },
                layouts = {
                    ivy = {
                        layout = {
                            box = "vertical",
                            backdrop = false,
                            width = 0,
                            height = height,
                            row = row,
                            border = "top",
                            title = " {title} {live} {flags}",
                            title_pos = "left",
                            {
                                win = "input",
                                height = 1,
                                border = "bottom",
                                wo = { winhighlight = custom_hl },
                            },
                            {
                                box = "horizontal",
                                {
                                    win = "list",
                                    border = "none",
                                    wo = { winhighlight = custom_hl },
                                },
                                {
                                    win = "preview",
                                    width = 0.6,
                                    border = "left",
                                    wo = { winhighlight = custom_hl },
                                },
                            },
                        },
                        on_win = apply_todo_highlights,
                    },
                    ivy_no_preview = {
                        layout = {
                            box = "vertical",
                            backdrop = false,
                            width = 0,
                            height = height,
                            row = row,
                            border = "top",
                            title = " {title} {live} {flags}",
                            title_pos = "left",
                            {
                                win = "input",
                                height = 1,
                                border = "bottom",
                                wo = { winhighlight = custom_hl },
                            },
                            {
                                box = "horizontal",
                                {
                                    win = "list",
                                    border = "none",
                                    wo = { winhighlight = custom_hl },
                                },
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
                            signcolumn = "auto:1",
                            cursorlineopt = "both",
                        },
                    },
                },
            },
        })

        for method, key in pairs(Mappings) do
            if method ~= "nvim_config" and method ~= "todos" then
                vim.keymap.set("n", key, function()
                    local opts = {}
                    if method == "files" then
                        opts = { hidden = true, follow = true, ignored = true }
                    elseif method == "icons" then
                        opts = {
                            layout = { preset = "select_icons", layout = { relative = "cursor" } },
                            custom_sources = {
                                my_custom_icons = vim.fn.stdpath("config") .. "/lua/lib/icons.json",
                            },
                            icon_sources = { "my_custom_icons" },
                            format = function(item, _)
                                local icon = item.icon or ""
                                local name = item.name or ""
                                local category = item.category or ""
                                local icon_col = string.format("%-3s", icon)
                                local name_col = string.format("%-38s", name)
                                return {
                                    { icon_col, "Number" },
                                    { "  " },
                                    { name_col, "Pmenu" },
                                    { "  " },
                                    { category, "Comment" },
                                }
                            end,
                        }
                    elseif method == "keymaps" then
                        opts = {
                            layout = { preset = "ivy_no_preview" },
                        }
                    elseif method == "command_history" then
                        opts = {
                            layout = { preset = "ivy_no_preview" },
                        }
                    elseif method == "search_history" then
                        opts = {
                            layout = { preset = "ivy_no_preview" },
                        }
                    end
                    require("snacks").picker.pick(method, opts)
                end)
            end
        end

        vim.keymap.set("n", Mappings.nvim_config, function()
            require("snacks.picker").files({
                title = "Neovim Config",
                cwd = vim.fn.stdpath("config"),
                hidden = true,
            })
        end, { desc = "Find Neovim Config" })
        vim.keymap.set("n", Mappings.todos, function()
            require("snacks.picker").grep({
                title = "Find Todo",
                search = [[\b(TODO|FIXME|FIX|HACK|WARN|PERF|TEST|BUG|NOTE):]],
                regex = true,
                live = false,
            })
        end)
    end,
}
