return {
    "lualine.nvim",
    spec = { src = "https://github.com/nvim-lualine/lualine.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    after = function()
        local mytheme = package.loaded["plugins.custom.colorscheme.integrations.lualine"].mytheme
        local component = require("plugins.extra.lualine-component")

        require("lualine").setup({
            options = {
                component_separators = { left = "", right = "" },
                globalstatus = true,
                section_separators = { left = "", right = "" },
                theme = mytheme,
                always_show_tabline = true,
            },
            sections = {
                lualine_a = {
                    {
                        "mode",
                        padding = { left = 1, right = 0 },
                        separator = "▕",
                    },
                    "fileformat",
                },
                lualine_b = {
                    {
                        "tabs",
                        cond = function()
                            return vim.fn.tabpagenr("$") > 1
                        end,
                        show_modified_status = false,
                        use_mode_colors = true,
                    },
                    component.get_cwd,
                },
                lualine_c = {
                    component.filename,
                    {
                        function()
                            return component.separator("-")
                        end,
                        padding = { left = 0, right = 1 },
                    },
                    {
                        "filesize",
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
                        update_in_insert = false,
                        separator = "│",
                    },
                    {
                        component.macro,
                        separator = "│",
                        color = mytheme.custom.b,
                    },
                    {
                        function()
                            return " " .. require("dap").status()
                        end,
                        cond = function()
                            return package.loaded["dap"] and require("dap").status() ~= ""
                        end,
                        color = mytheme.custom.c,
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
                    {
                        function()
                            if package.loaded["opencode"] then
                                local ok, statusline = pcall(function()
                                    return require("opencode").statusline()
                                end)

                                if ok and statusline then
                                    return statusline
                                end
                            end
                            return "󱚧"
                        end,
                        separator = "│",
                    },
                    component.lsp_status,
                },
            },
        })
    end,
}
