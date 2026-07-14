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
    -- lsp stuff
    lsp_config = "grc",
    lsp_definitions = "gd",
    lsp_declarations = "gD",
    lsp_implementations = "gri",
    lsp_type_definitions = "grt",
    lsp_symbols = "gO",
    lsp_references = "grr",
    lsp_workspace_symbols = "gW",
}

local lz_keys = {}
for _, key_combo in pairs(Mappings) do
    table.insert(lz_keys, { key_combo })
end

return {
    "snacks.nvim",
    spec = { src = "https://github.com/folke/snacks.nvim" },
    keys = lz_keys,
    event = { "BufReadPre", "BufNewFile" },
    after = function()
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
        require("snacks").setup({
            bigfile = { enabled = true },
            image = { enabled = false },
            input = { enabled = true },
            picker = {
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
            },
        })
        -- generate description
        local function get_desc(method_name)
            if string.match(method_name, "^lsp_") then
                local clean_name = string.gsub(method_name, "^lsp_", "")
                clean_name = string.gsub(clean_name, "_", " ")
                clean_name = string.gsub(clean_name, "(%a)([%w]*)", function(first, rest)
                    return string.upper(first) .. rest
                end)
                return "LSP: " .. clean_name
            else
                local clean_name = string.gsub(method_name, "_", " ")
                clean_name = string.gsub(clean_name, "(%a)([%w]*)", function(first, rest)
                    return string.upper(first) .. rest
                end)
                return "Find " .. clean_name
            end
        end

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
                            layout = { preset = "ivy" },
                        }
                    elseif method == "command_history" then
                        opts = {
                            layout = { preset = "ivy" },
                        }
                    elseif method == "search_history" then
                        opts = {
                            layout = { preset = "ivy" },
                        }
                    end
                    require("snacks").picker.pick(method, opts)
                end, { desc = get_desc(method) })
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
        end, { desc = "Find Todo" })
    end,
}
