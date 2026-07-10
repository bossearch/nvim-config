return {
    "lualine.nvim",
    spec = { src = "https://github.com/nvim-lualine/lualine.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    before = function()
        require("lz.n").trigger_load("noice.nvim")
    end,
    after = function()
        require("lualine").setup({
            options = {
                component_separators = { left = "", right = "" },
                disabled_filetypes = { statusline = { "dashboard", "alpha" } },
                globalstatus = true,
                section_separators = { left = "", right = "" },
                theme = _G.lualine_theme,
                always_show_tabline = true,
            },
            sections = {
                lualine_a = {
                    "mode",
                    {
                        "tabs",
                        cond = function()
                            return vim.fn.tabpagenr("$") > 1
                        end,
                        show_modified_status = false,
                        use_mode_colors = true,
                    },
                },
                lualine_b = { { require("lib.util").get_cwd, icon = "󰝰" } },
                lualine_c = {
                    {
                        "buffers",
                        show_filename_only = false,
                        hide_filename_extension = false,
                        show_modified_status = true,
                        mode = 0,
                        max_length = vim.o.columns - 65,
                        filetype_names = {
                            TelescopePrompt = "",
                        },

                        symbols = {
                            modified = " ●",
                            alternate_file = "",
                            directory = "",
                        },
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
                        require("noice").api.status.mode.get,
                        cond = require("noice").api.status.mode.has,
                        color = _G.lualine_theme.normal.x_1,
                        separator = "│",
                    },
                    {
                        function()
                            return " " .. require("dap").status()
                        end,
                        cond = function()
                            return package.loaded["dap"] and require("dap").status() ~= ""
                        end,
                        color = _G.lualine_theme.normal.x_2,
                        separator = "│",
                    },
                },
                lualine_y = {
                    {
                        "filesize",
                        separator = "│",
                    },
                    "%l/%L:%c",
                },
                lualine_z = {
                    {
                        "lsp_status",
                        icon = "󰒋",
                        symbols = {
                            spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
                            done = "",
                            separator = "│",
                        },
                        ignore_lsp = {},
                        show_name = true,
                    },
                },
            },
        })
    end,
}
