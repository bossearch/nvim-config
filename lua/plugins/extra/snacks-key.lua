local Mappings = {
    files = "<leader><leader>f",
    nvim_config = "<leader><leader>c",
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

local keymap = function()
    local function get_desc(method_name) -- generate description
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
                    opts = { hidden = true, follow = true, ignored = true, matcher = { sort_empty = true } }
                elseif method == "icons" then
                    opts = {
                        layout = { preset = "select" },
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
                                { name_col, "Normal" },
                                { "  " },
                                { category, "SpecialKey" },
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
end

return {
    keys = lz_keys,
    keymap = keymap,
}
