return {
    {
        "blink.cmp",
        spec = {
            src = "https://github.com/saghen/blink.cmp",
            version = "v1",
        },
        event = { "InsertEnter", "CmdlineEnter" },
        before = function()
            require("lz.n").trigger_load("blink-ripgrep.nvim")
        end,
        after = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

            vim.lsp.config("*", {
                capabilities = capabilities,
            })

            local score = {
                buffer = 10,
                lsp = 80,
                path = 70,
                ripgrep = 50,
                snippets = 90,
                cmdline = 20,
            }

            require("blink.cmp").setup({
                appearance = {
                    kind_icons = {
                        Class = "",
                        Color = "",
                        Constant = "",
                        Constructor = "",
                        Copilot = "",
                        Enum = "",
                        EnumMember = "",
                        Event = "",
                        Field = "",
                        File = "",
                        Folder = "",
                        Function = "󰊕",
                        Interface = "",
                        Keyword = "",
                        Method = "",
                        Module = "󱒌",
                        Operator = "",
                        Property = "",
                        Reference = "",
                        Snippet = "",
                        Struct = "",
                        Text = "",
                        TypeParameter = "",
                        Unit = "",
                        Value = "",
                        Variable = "",
                        Warning = "",
                    },
                    nerd_font_variant = "normal",
                },
                cmdline = {
                    keymap = { preset = "inherit" },
                    completion = { menu = { auto_show = true } },
                },
                completion = {
                    accept = { auto_brackets = { enabled = false } },
                    documentation = { auto_show = true },
                    menu = {
                        draw = {
                            columns = { { "label", "label_description", gap = 1 }, { "kind", gap = 1, "kind_icon" } },
                        },
                    },
                },
                keymap = {
                    preset = "none",
                    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                    ["<C-e>"] = { "hide", "fallback" },
                    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
                    ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
                    ["<C-n>"] = { "select_next", "fallback_to_mappings" },
                    ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
                    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                    ["<C-y>"] = { "select_and_accept", "fallback" },
                    ["<S-Tab>"] = { "snippet_backward", "fallback" },
                    ["<Tab>"] = { "snippet_forward", "fallback" },
                },
                snippets = { preset = "default" },
                sources = {
                    default = { "lsp", "snippets", "path", "ripgrep" },
                    providers = {
                        buffer = {
                            enabled = true,
                            async = true,
                            min_keyword_length = 1,
                            module = "blink.cmp.sources.buffer",
                            opts = {
                                get_bufnrs = function()
                                    return vim.tbl_filter(function(bufnr)
                                        return vim.bo[bufnr].buftype == ""
                                    end, vim.api.nvim_list_bufs())
                                end,
                            },
                            score_offset = score.buffer,
                        },
                        cmdline = {
                            module = "blink.cmp.sources.cmdline",
                            score_offset = score.cmdline,
                        },
                        lsp = {
                            enabled = true,
                            async = true,
                            fallbacks = { "buffer" },
                            min_keyword_length = 0,
                            module = "blink.cmp.sources.lsp",
                            name = "lsp",
                            score_offset = score.lsp,
                            timeout_ms = 2000,
                        },
                        path = {
                            enabled = true,
                            async = true,
                            fallbacks = { "buffer" },
                            min_keyword_length = 0,
                            module = "blink.cmp.sources.path",
                            name = "path",
                            opts = {
                                get_cwd = function(_)
                                    return vim.fn.getcwd()
                                end,
                                label_trailing_slash = true,
                                show_hidden_files_by_default = true,
                                trailing_slash = false,
                            },
                            score_offset = score.path,
                        },
                        ripgrep = {
                            enabled = true,
                            async = true,
                            fallbacks = { "buffer" },
                            module = "blink-ripgrep",
                            name = "grep",
                            opts = {
                                prefix_min_len = 2,
                                backend = {
                                    use = "gitgrep",
                                    max_filesize = "1M",
                                    project_root_fallback = true,
                                },
                                debug = false,
                            },
                            score_offset = score.ripgrep,
                        },
                        snippets = {
                            enabled = true,
                            async = true,
                            min_keyword_length = 0,
                            module = "blink.cmp.sources.snippets",
                            name = "snip",
                            opts = { show_autosnippets = true, use_show_condition = true },
                            score_offset = score.snippets,
                        },
                    },
                },
                term = { enabled = false },
            })
        end,
    },
    {
        "blink-ripgrep.nvim",
        spec = { src = "https://github.com/mikavilpas/blink-ripgrep.nvim" },
        lazy = true,
    },
}
