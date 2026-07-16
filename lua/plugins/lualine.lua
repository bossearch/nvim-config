return {
    "lualine.nvim",
    spec = { src = "https://github.com/nvim-lualine/lualine.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    after = function()
        require("lualine").setup({
            options = {
                component_separators = { left = "", right = "" },
                disabled_filetypes = { statusline = { "alpha" } },
                globalstatus = true,
                section_separators = { left = "", right = "" },
                theme = _G.lualine_theme,
                always_show_tabline = true,
            },
            tabline = {
                lualine_c = {
                    {
                        "buffers",
                        show_filename_only = true,
                        hide_filename_extension = false,
                        show_modified_status = true,
                        mode = 0,
                        max_length = function()
                            local tab_count = vim.fn.tabpagenr("$")
                            local tab_offset = tab_count > 1 and (tab_count * 3) or 0
                            return math.max(vim.o.columns - tab_offset)
                        end,
                        filetype_names = {
                            oil = "Oil",
                            qf = " Quickfix",
                            snacks_picker_input = "󰢷 Picker",
                        },

                        symbols = {
                            modified = " ●",
                            alternate_file = "",
                            directory = "",
                        },
                        use_mode_colors = false,
                        buffers_color = {
                            active = _G.lualine_theme.custom.a,
                        },
                    },
                },
                lualine_y = {
                    {
                        "tabs",
                        cond = function()
                            return vim.fn.tabpagenr("$") > 1
                        end,
                        show_modified_status = false,
                        use_mode_colors = true,
                    },
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "fileformat", "encoding" },
                lualine_c = {
                    {
                        require("lib.util").get_cwd,
                        padding = { left = 1, right = 0 },
                        separator = false,
                    },
                    {
                        function()
                            return require("lib.util").separator("/")
                        end,
                        color = _G.lualine_theme.custom.a,
                        padding = { left = 0, right = 0 },
                    },
                    {
                        require("lib.util").filename,
                        color = _G.lualine_theme.custom.a,
                        padding = { left = 0, right = 1 },
                    },
                    {
                        function()
                            return require("lib.util").separator("-")
                        end,
                        color = _G.lualine_theme.custom.a,
                        padding = { left = 0, right = 1 },
                    },
                    {
                        "filesize",
                        color = _G.lualine_theme.custom.a,
                        padding = { left = 0, right = 1 },
                    },
                },
                lualine_x = {
                    {
                        "diff",
                        source = function()
                            local summary = vim.b.minidiff_summary
                            if summary then
                                return {
                                    added = summary.add,
                                    modified = summary.change,
                                    removed = summary.delete,
                                }
                            end
                        end,
                        separator = "│",
                    },
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        symbols = {
                            error = "E",
                            warn = "W",
                            info = "I",
                            hint = "H",
                        },
                        colored = true,
                        update_in_insert = false,
                        separator = "│",
                    },
                    {
                        function()
                            return " " .. require("dap").status()
                        end,
                        cond = function()
                            return package.loaded["dap"] and require("dap").status() ~= ""
                        end,
                        color = _G.lualine_theme.custom.c,
                        separator = "│",
                    },
                },
                lualine_y = {
                    function()
                        return string.format(
                            "%d%%%%/%d:%02d/%02d",
                            math.floor(vim.fn.line(".") / vim.fn.line("$") * 100),
                            vim.fn.line("$"),
                            vim.fn.virtcol("."),
                            vim.fn.virtcol({ vim.fn.line("."), "$" }) - 1
                        )
                    end,
                },
                lualine_z = {
                    require("lib.util").no_lsp,
                    {
                        "lsp_status",
                        icon = false,
                        symbols = {
                            spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
                            done = "󰒋",
                            separator = "│",
                        },
                        ignore_lsp = { "render-markdown" },
                        show_name = true,
                    },
                },
            },
        })
    end,
}
